/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2019-2022
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

class ts_Api
{

  static
  ts_Api from()
  {
    let result = new("ts_Api");
    result._hasTarget        = Cvar.getCvar("m8f_ts_has_target",      players[consolePlayer]);
    result._isFriendlyTarget = Cvar.getCvar("m8f_ts_friendly_target", players[consolePlayer]);
    return result;
  }

  void setHasTarget       (bool hasTarget)        { _hasTarget.setInt(hasTarget); }
  void setIsFriendlyTarget(bool isFriendlyTarget) { _isFriendlyTarget.setInt(isFriendlyTarget); }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private Cvar _hasTarget;
  private Cvar _isFriendlyTarget;

} // class ts_Api
