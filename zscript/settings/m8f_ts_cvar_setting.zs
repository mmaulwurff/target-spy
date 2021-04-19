/* Copyright Alexander 'm8f' Kromm (mmaulwurff@gmail.com) 2019-2021
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
 * This class represents a single setting.
 */
class m8f_ts_CvarSetting
{

  // public: ///////////////////////////////////////////////////////////////////

  m8f_ts_CvarSetting init(string cvarName, PlayerInfo p)
  {
    _cvar = CVar.GetCvar(cvarName, p);
    return self;
  }

  // protected: ////////////////////////////////////////////////////////////////

  protected
  Cvar variable() { return _cvar; }

  // private: //////////////////////////////////////////////////////////////////

  private transient CVar _cvar;

} // class m8f_ts_CvarSetting
