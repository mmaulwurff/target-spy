/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2018-2019
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

class m8f_ts_ActorInfo
{

  // public: ///////////////////////////////////////////////////////////////////

  static ui
  string GetTargetFlags(Actor target)
  {
    string result = "";

    if (target.bFRIENDLY && !target.player) { result = m8f_ts_String.appendWithSpace(result, "Friendly"    ); }
    if (target.bINVULNERABLE              ) { result = m8f_ts_String.appendWithSpace(result, "Invulnerable"); }
    if (target.bBOSS                      ) { result = m8f_ts_String.appendWithSpace(result, "Boss"        ); }
    if (target.bDORMANT                   ) { result = m8f_ts_String.appendWithSpace(result, "Dormant"     ); }
    if (target.bBUDDHA                    ) { result = m8f_ts_String.appendWithSpace(result, "Buddha"      ); }
    if (target.bNODAMAGE                  ) { result = m8f_ts_String.appendWithSpace(result, "Undamageable"); }

    return result;
  }

  static ui
  int GetActorMaxHealth(Actor a)
  {
    if (a == null)     { return 0; }
    if (!a.bSHOOTABLE) { return 0; }

    if (a.player && a.player.mo) { return a.player.mo.GetMaxHealth(); }

    int maxHealth = a.SpawnHealth();
    return maxHealth;
  }

  static ui
  bool IsIdle(Actor a)
  {
    return a.target == null;
  }

  static ui
  int CustomTargetColor(Actor target)
  {
    string customColorTokenClass = "tr_color_token";
    int customColor = target.CountInv(customColorTokenClass);
    return customColor;
  }

} // class m8f_ts_ActorInfo
