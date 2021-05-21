/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2019-2021
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

class ts_ActorInfo
{

// public: /////////////////////////////////////////////////////////////////////

  static ui
  string getTargetFlags(Actor target)
  {
    string result = "";

    string drpgToken = "DRPGMonsterStatsHandler";
    if (target.countInv(drpgToken) > 0)
    {
      ts_ActorInfoHelper helper;
      result = string.format("LVL %d", helper.getDrpgLevel(target));
    }

    if (target.bFRIENDLY && !target.player) result = ts_String.appendWithSpace(result, "Friendly"    );
    if (target.bINVULNERABLE              ) result = ts_String.appendWithSpace(result, "Invulnerable");
    if (target.bBOSS                      ) result = ts_String.appendWithSpace(result, "Boss"        );
    if (target.bDORMANT                   ) result = ts_String.appendWithSpace(result, "Dormant"     );
    if (target.bBUDDHA                    ) result = ts_String.appendWithSpace(result, "Buddha"      );
    if (target.bNODAMAGE                  ) result = ts_String.appendWithSpace(result, "Undamageable");
    if (target.bNoBlockmap                ) result = ts_String.appendWithSpace(result, "NoBlockmap"  );

    return result;
  }

  static ui
  int getActorMaxHealth(Actor a)
  {
    if (a == null)     { return 0; }
    if (!a.bSHOOTABLE) { return 0; }

    bool isMaxFromService;
    int maxFromService;
    [isMaxFromService, maxFromService] = getMaxFromService(a.GetClassName());
    if (isMaxFromService) { return maxFromService; }

    if (a.player && a.player.mo) { return a.player.mo.getMaxHealth(); }

    int maxHealth = a.spawnHealth();

    string drpgToken = "DRPGMonsterStatsHandler";
    if (a.countInv(drpgToken) > 0)
    {
      ts_ActorInfoHelper helper;
      maxHealth = helper.getDrpgMaxHealth(a);
    }

    string legendaryToken = "LDLegendaryMonsterToken";
    if (a.countInv(legendaryToken) > 0)
    {
      maxHealth = maxHealth * Cvar.getCvar("LD_legendaryHealth").getInt() / 100;
    }

    return maxHealth;
  }

  static ui
  bool isIdle(Actor a)
  {
    return a.target == null;
  }

  static ui
  int customTargetColor(Actor target)
  {
    string customColorTokenClass = "tr_color_token";
    int customColor = target.countInv(customColorTokenClass);
    return customColor;
  }

// private /////////////////////////////////////////////////////////////////////////////////////////

  static ui
  bool, int getMaxFromService(string className)
  {
    ServiceIterator i = ServiceIterator.Find("MaxHealthService");

    Service s;
    if (s = i.Next())
    {
      String maxHealth = s.UiGetData(className);
      if (maxHealth == "none")
      {
        return false, 0;
      }
      else
      {
        return true, maxHealth.ToInt();
      }
    }

    return false, 0;
  }

} // class ts_ActorInfo

class ts_ActorInfoHelper
{

// public: /////////////////////////////////////////////////////////////////////

  play
  int getDrpgMaxHealth(Actor a) const
  {
    return a.ACS_ScriptCall("GetMonsterHealthMax");
  }

  play
  int getDrpgLevel(Actor a) const
  {
    return a.ACS_ScriptCall("GetMonsterLevel");
  }

} // class ts_ActorInfoHelper
