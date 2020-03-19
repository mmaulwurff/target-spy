/* Copyright Alexander 'm8f' Kromm (mmaulwurff@gmail.com) 2019-2020
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
 * This class represents a pack of settings.
 */
class m8f_ts_SettingsPack : m8f_ts_SettingsBase
{

  void init(PlayerInfo player)
  {
    _player = player;
  }

  // public: ///////////////////////////////////////////////////////////////////

  override
  void resetCvarsToDefaults()
  {
    int nSettings = _settings.size();
    for (int i = 0; i < nSettings; ++i)
    {
      _settings[i].resetCvarsToDefaults();
    }
  }

  // protected: ////////////////////////////////////////////////////////////////

  protected void push(m8f_ts_SettingsBase setting) { _settings.push(setting); }
  protected void clear()                           { _settings.clear();       }

  // protected: ////////////////////////////////////////////////////////////////

  protected PlayerInfo     _player;
  protected transient bool _isInitialized;

  // private: //////////////////////////////////////////////////////////////////

  private Array<m8f_ts_SettingsBase> _settings;

} // class m8f_ts_SettingsPack : m8f_ts_SettingsBase
