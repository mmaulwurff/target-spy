/* Copyright Alexander 'm8f' Kromm (mmaulwurff@gmail.com) 2018-2019
 *
 * This file is a part of Target Spy.
 *
 * Target Spy is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * Target Spy is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Target Spy.  If not, see <https://www.gnu.org/licenses/>.
 */

/**
 * This class provides the base functions for various settings classes.
 */
class m8f_ts_SettingsBase
{

  // public: ///////////////////////////////////////////////////////////////////

  /**
   * Reset CVars to their default values.
   */
  virtual
  void resetCvarsToDefaults()
  {
    console.printf("%s: reset is not implemented!", GetClassName());
  }

} // class m8f_ts_SettingsBase
