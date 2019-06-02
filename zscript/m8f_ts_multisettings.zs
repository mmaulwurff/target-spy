/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2018-2019
 *
 * This file is part of Target Spy.
 *
 * Target Spy is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Target Spy is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Target Spy.  If not, see <https://www.gnu.org/licenses/>.
 */

class m8f_ts_MultiSettings
{

  // public: ///////////////////////////////////////////////////////////////////

  m8f_ts_MultiSettings init()
  {
    for (int i = 0; i < MAXPLAYERS; ++i)
    {
      let setting = new("m8f_ts_Settings");
      setting.init(players[i]);
      _settingsArray.push(setting);
    }

    return self;
  }

  m8f_ts_Settings get(int playerNumber)
  {
    return _settingsArray[playerNumber];
  }

  // private: //////////////////////////////////////////////////////////////////

  private Array<m8f_ts_Settings> _settingsArray;

} // class m8f_ts_MultiSettings
