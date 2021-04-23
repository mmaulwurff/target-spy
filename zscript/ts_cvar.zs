/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2021
 *
 * This file is part of Target Spy.
 *
 * Target Spy is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * Target Spy is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Target Spy.  If not, see <https://www.gnu.org/licenses/>.
 */

/**
 * This class provides access to a user or server Cvar.
 *
 * Accessing Cvars through this class is faster because calling Cvar.GetCvar()
 * is costly. This class caches the result of Cvar.GetCvar() and handles
 * loading a savegame.
 */
class ts_Cvar
{

  static
  ts_Cvar from(string name)
  {
    let result = new("ts_Cvar");
    result.mName = name;
    result.load();
    return result;
  }

  string getString() { if (!mCvar) load(); return mCvar.getString(); }
  bool   getBool()   { if (!mCvar) load(); return mCvar.getInt();    }
  int    getInt()    { if (!mCvar) load(); return mCvar.getInt();    }
  double getDouble() { if (!mCvar) load(); return mCvar.getFloat();  }

  void setBool(bool value) { if (!mCvar) load(); mCvar.setInt(value); }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void load()
  {
    mCvar = Cvar.getCvar(mName, players[consolePlayer]);

    if (mCvar == NULL)
    {
      Console.printf("cvar %s not found", mName);
    }
  }

  private string         mName;
  private transient Cvar mCvar;

} // class ts_Cvar
