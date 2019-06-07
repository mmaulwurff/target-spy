enum m8f_ts_VectorType {
	m8f_ts_Vector_Position,
	m8f_ts_Vector_Direction
}

class m8f_ts_Matrix {
	private Array<double> values;
	private int columns;
	private int rows;

	/// Initialises a new Matrix.
	m8f_ts_Matrix init(int columns, int rows) {
		if (columns <= 0 || rows <= 0) {
			throwAbortException("Error: <%p>.init(%d, %d) - Matrix needs to be at least 1 * 1", self, columns, rows);
		}

		self.rows = rows;
		self.columns = columns;
		values.resize(columns * rows);
		for (int i = 0; i < values.size(); i++) {
			values[i] = 0;
		}

		return self;
	}

	/// Initialises a new Matrix in a static context.
	static m8f_ts_Matrix create(int columns, int rows) {
		return new("m8f_ts_Matrix").init(columns, rows);
	}

	/// Returns an identity matrix.
	static m8f_ts_Matrix identity(int dimension) {
		m8f_ts_Matrix ret = m8f_ts_Matrix.create(dimension, dimension);
		for (int i = 0; i < dimension; i++) {
			ret.set(i, i, 1);
		}
		return ret;
	}

	/// Returns a rotation matrix from euler angles.
	static m8f_ts_Matrix fromEulerAngles(double yaw, double pitch, double roll) {
		m8f_ts_Matrix rYaw = m8f_ts_Matrix.identity(4);
		double sYaw = sin(yaw);
		double cYaw = cos(yaw);
		rYaw.set(0, 0,  cYaw);
		rYaw.set(1, 0, -sYaw);
		rYaw.set(0, 1,  sYaw);
		rYaw.set(1, 1,  cYaw);

		m8f_ts_Matrix rPitch = m8f_ts_Matrix.identity(4);
		double sPitch = sin(pitch);
		double cPitch = cos(pitch);
		rPitch.set(0, 0,  cPitch);
		rPitch.set(0, 2, -sPitch);
		rPitch.set(2, 0,  sPitch);
		rPitch.set(2, 2,  cPitch);

		m8f_ts_Matrix rRoll = m8f_ts_Matrix.identity(4);
		double sRoll = sin(roll);
		double cRoll = cos(roll);
		rRoll.set(1, 1,  cRoll);
		rRoll.set(2, 1, -sRoll);
		rRoll.set(1, 2,  sRoll);
		rRoll.set(2, 2,  cRoll);

		// concatenate ypr to get the final matrix
		m8f_ts_Matrix ret = rYaw.multiplyMatrix(rPitch);
		ret = ret.multiplyMatrix(rRoll);
		return ret;
	}

	/// Returns a rotation matrix from an axis and an angle.
	static m8f_ts_Matrix fromAxisAngle(Vector3 axis, double angle) {
		m8f_ts_Matrix ret = m8f_ts_Matrix.identity(4);
		double c = cos(angle);
		double s = sin(angle);
		double x = axis.x;
		double y = axis.y;
		double z = axis.z;

		ret.set(0, 0, (x * x * (1.0 - c) + c));
		ret.set(1, 0, (x * y * (1.0 - c) - z * s));
		ret.set(2, 0, (x * z * (1.0 - c) + y * s));
		ret.set(0, 1, (y * x * (1.0 - c) + z * s));
		ret.set(1, 1, (y * y * (1.0 - c) + c));
		ret.set(2, 1, (y * z * (1.0 - c) - x * s));
		ret.set(0, 2, (x * z * (1.0 - c) - y * s));
		ret.set(1, 2, (y * z * (1.0 - c) + x * s));
		ret.set(2, 2, (z * z * (1.0 - c) + c));

		return ret;
	}

	/// Converts back from the rotation matrix to euler angles.
	double, double, double rotationToEulerAngles() {
		if (m8f_ts_GlobalMaths.closeEnough(get(0, 2), -1)) {
			double x = 90;
			double y = 0;
			double z = atan2(get(1, 0), get(2, 0));
			return z, x, y;
		}
		else if (m8f_ts_GlobalMaths.closeEnough(get(0, 2), 1)) {
			double x = -90;
			double y = 0;
			double z = atan2(-get(1, 0), -get(2, 0));
			return z, x, y;
		}
		else {
			double x1 = -asin(get(0, 2));
			double x2 = 180 - x1;

			double y1 = atan2(get(1, 2) / cos(x1), get(2, 2) / cos(x1));
			double y2 = atan2(get(1, 2) / cos(x2), get(2, 2) / cos(x2));

			double z1 = atan2(get(0, 1) / cos(x1), get(0, 0) / cos(x1));
			double z2 = atan2(get(0, 1) / cos(x2), get(0, 0) / cos(x2));

			if ((abs(x1) + abs(y1) + abs(z1)) <= (abs(x2) + abs(y2) + abs(z2))) {
				return z1, x1, y1;
			}
			else {
				return z2, x2, y2;
			}
		}
	}
	
	static m8f_ts_Matrix createTRSEuler(Vector3 translate, double yaw, double pitch, double roll, Vector3 scale) {
		m8f_ts_Matrix translateMat = m8f_ts_Matrix.identity(4);
		translateMat.set(3, 0, translate.x);
		translateMat.set(3, 1, translate.y);
		translateMat.set(3, 2, translate.z);
		
		m8f_ts_Matrix rotateMat = m8f_ts_Matrix.fromEulerAngles(yaw, pitch, roll);
		
		m8f_ts_Matrix scaleMat = m8f_ts_Matrix.identity(4);
		scaleMat.set(0, 0, scale.x);
		scaleMat.set(1, 1, scale.y);
		scaleMat.set(2, 2, scale.z);
		
		m8f_ts_Matrix ret = translateMat.multiplyMatrix(rotateMat);
		ret = ret.multiplyMatrix(scaleMat);
		return ret;
	}
	
	static m8f_ts_Matrix createTRSAxisAngle(Vector3 translate, Vector3 axis, double angle, Vector3 scale) {
		m8f_ts_Matrix translateMat = m8f_ts_Matrix.identity(4);
		translateMat.set(3, 0, translate.x);
		translateMat.set(3, 1, translate.y);
		translateMat.set(3, 2, translate.z);
		
		m8f_ts_Matrix rotateMat = m8f_ts_Matrix.fromAxisAngle(axis, angle);
		
		m8f_ts_Matrix scaleMat = m8f_ts_Matrix.identity(4);
		scaleMat.set(0, 0, scale.x);
		scaleMat.set(1, 1, scale.y);
		scaleMat.set(2, 2, scale.z);
		
		m8f_ts_Matrix ret = translateMat.multiplyMatrix(rotateMat);
		ret = ret.multiplyMatrix(scaleMat);
		return ret;
	}

	/// Returns a view matrix.
	static m8f_ts_Matrix view(Vector3 camPos, double yaw, double pitch, double roll) {
		// all of this is basically lifted and converted from PolyRenderer::SetupPerspectiveMatrix(),
		// so credit goes to Graf Zahl/dpJudas/whoever else
		// pitch needs to be adjusted by the pixel ratio
		double pixelRatio = level.pixelstretch;
		double angx = cos(pitch);
		double angy = sin(pitch) * pixelRatio;
		double alen = sqrt(angx * angx + angy * angy);
		double adjustedPitch = asin(angy / alen);
		double adjustedYaw = yaw - 90;

		// rotations
		m8f_ts_Matrix rotR = m8f_ts_Matrix.fromAxisAngle((0, 0, 1), roll);
		m8f_ts_Matrix rotP = m8f_ts_Matrix.fromAxisAngle((1, 0, 0), adjustedPitch);
		m8f_ts_Matrix rotY = m8f_ts_Matrix.fromAxisAngle((0, -1, 0), adjustedYaw);
		// pixel ratio scaling
		m8f_ts_Matrix scale = m8f_ts_Matrix.identity(4);
		scale.set(1, 1, pixelRatio);
		// swapping y and z
		m8f_ts_Matrix swapYZ = m8f_ts_Matrix.create(4, 4);
		swapYZ.set(0, 0, 1);
		swapYZ.set(2, 1, 1);
		swapYZ.set(1, 2, -1);
		swapYZ.set(3, 3, 1);
		// translation
		m8f_ts_Matrix translate = m8f_ts_Matrix.identity(4);
		translate.set(3, 0, -camPos.x);
		translate.set(3, 1, -camPos.y);
		translate.set(3, 2, -camPos.z);

		// concatenate them all to get a final matrix
		m8f_ts_Matrix ret = rotR.multiplyMatrix(rotP);
		ret = ret.multiplyMatrix(rotY);
		ret = ret.multiplyMatrix(scale);
		ret = ret.multiplyMatrix(swapYZ);
		ret = ret.multiplyMatrix(translate);
		return ret;
	}

	/// Returns a perspective matrix (same format as gluPerspective).
	static m8f_ts_Matrix perspective(double fovy, double aspect, double zNear, double zFar) {
		m8f_ts_Matrix ret = m8f_ts_Matrix.create(4, 4);
		double f = 1 / tan(fovy / 2.0);
		// x coord
		ret.set(0, 0, f / aspect);
		// y coord
		ret.set(1, 1, f);
		// z buffer coord
		ret.set(2, 2, (zFar + zNear) / (zNear - zFar));
		ret.set(3, 2, (2 * zFar * zNear) / (zNear - zFar));
		// w (homogeneous coordinates)
		ret.set(2, 3, -1);
		return ret;
	}

	/// Returns a world->clip coords matrix from the passed args.
	static m8f_ts_Matrix worldToClip(Vector3 viewPos, double yaw, double pitch, double roll, double FOV) {
		double aspect = Screen.getAspectRatio();
		double fovy = m8f_ts_GlobalMaths.fovHToY(FOV);
		m8f_ts_Matrix view = m8f_ts_Matrix.view(viewPos, yaw, pitch, roll);
		// 5 & 65535 are what are used internally, so they're used here for consistency
		m8f_ts_Matrix perp = m8f_ts_Matrix.perspective(fovy, aspect, 5, 65535);
		m8f_ts_Matrix worldToClip = perp.multiplyMatrix(view);
		return worldToClip;
	}

	/// Gets the value at col, row.
	double get(int col, int row) const {
		return values[columns * row + col];
	}

	/// Sets the value at col, row.
	void set(int col, int row, double val) {
		values[columns * row + col] = val;
	}

	/// Adds two matrices and returns the result.
	m8f_ts_Matrix addMatrix(m8f_ts_Matrix other) const {
		if (rows != other.rows || columns != other.columns) {
			throwAbortException("Error: <%p>.addMatrix(<%p>) - Matrices need to be equal size", self, other);
		}
		m8f_ts_Matrix ret = m8f_ts_Matrix.create(columns, rows);
		for (int row = 0; row < rows; row++) {
			for (int col = 0; col < columns; col++) {
				ret.set(col, row, get(col, row) + other.get(col, row));
			}
		}
		return ret;
	}

	/// Multiplies the matrix by a scalar and returns the result.
	m8f_ts_Matrix multiplyScalar(double scalar) const {
		m8f_ts_Matrix ret = m8f_ts_Matrix.create(rows, columns);
		for (int row = 0; row < rows; row++) {
			for (int col = 0; col < columns; col++) {
				ret.set(col, row, get(col, row) * scalar);
			}
		}
		return ret;
	}

	/// Multiplies two matrices and returns the result.
	m8f_ts_Matrix multiplyMatrix(m8f_ts_Matrix other) const {
		if (columns != other.rows) {
			throwAbortException("Error: <%p>.multiplyMatrix(<%p>) - Matrix A columns needs to equal Matrix B rows", self, other);
		}
		m8f_ts_Matrix ret = m8f_ts_Matrix.create(other.columns, rows);
		for (int row = 0; row < ret.rows; row++) {
			for (int col = 0; col < ret.columns; col++) {
				double val = 0;
				for (int i = 0; i < columns; i++) {
					val += get(i, row) * other.get(col, i);
				}
				ret.set(col, row, val);
			}
		}
		return ret;
	}

	/// Multiplies this Matrix by a 2D vector.
	m8f_ts_Matrix multiplyVector2(Vector2 vec, m8f_ts_VectorType type = m8f_ts_Vector_Position) const {
		m8f_ts_Matrix vec2Matrix = m8f_ts_Matrix.create(1, 3);
		vec2Matrix.set(0, 0, vec.x);
		vec2Matrix.set(0, 1, vec.y);
		if (type == m8f_ts_Vector_Position)       vec2Matrix.set(0, 2, 1);
		else if (type == m8f_ts_Vector_Direction) vec2Matrix.set(0, 2, 0);
		else throwAbortException("Error: Invalid vector type for multiplyVector2 (%d)", type);
		return multiplyMatrix(vec2Matrix);
	}

	/// Multiplies this Matrix by a 3D vector.
	m8f_ts_Matrix multiplyVector3(Vector3 vec, m8f_ts_VectorType type = m8f_ts_Vector_Position) const {
		m8f_ts_Matrix vec3Matrix = m8f_ts_Matrix.create(1, 4);
		vec3Matrix.set(0, 0, vec.x);
		vec3Matrix.set(0, 1, vec.y);
		vec3Matrix.set(0, 2, vec.z);
		if (type == m8f_ts_Vector_Position)       vec3Matrix.set(0, 3, 1);
		else if (type == m8f_ts_Vector_Direction) vec3Matrix.set(0, 3, 0);
		else throwAbortException("Error: Invalid vector type for multiplyVector3 (%d)", type);
		return multiplyMatrix(vec3Matrix);
	}

	/// Returns the Matrix in Vector2 form, optionally dividing by z.
	Vector2 asVector2(bool divideZ = true) const {
		if (columns != 1 || rows != 3) {
			throwAbortException("Error: <%p>.asVector2() - Matrix needs to be 1 * 3", self);
		}
		if (divideZ) return (get(0, 0), get(0, 1)) / get(0, 2);
		else         return (get(0, 0), get(0, 1));
	}

	/// Returns the Matrix in Vector3 form, optionally dividing by w.
	Vector3 asVector3(bool divideW = true) const {
		if (columns != 1 || rows != 4) {
			throwAbortException("Error: <%p>.asVector3() - Matrix needs to be 1 * 4", self);
		}
		if (divideW) return (get(0, 0), get(0, 1), get(0, 2)) / get(0, 3);
		else         return (get(0, 0), get(0, 1), get(0, 2));
	}

	/// Returns the number of columns.
	int getColumns() const {
		return columns;
	}

	/// Returns the number of rows.
	int getRows() const {
		return rows;
	}
}
