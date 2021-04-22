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
 * You should have received a copy of the GNU General Public License
 * along with Target Spy.  If not, see <https://www.gnu.org/licenses/>.
 */

class ts_Data
{

  Dictionary championTokens;

  static
  ts_Data from()
  {
    let result = new("ts_Data");

    result.championTokens = Dictionary.create();
    result._slaveActors   = Dictionary.create();
    result._blackList     = Dictionary.create();

    result.fillChampionTokens();
    result.fillSlaveActors();
    result.fillBlackList();

    return result;
  }

  bool slaveActorsContain(string className) const
  {
    return _slaveActors.at(className).length() != 0;
  }

  bool blackListContains(string className) const
  {
    return _blackList.at(className).length() != 0;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void fillChampionTokens()
  {
    championTokens.insert( "champion_BlackToken"     , "Brutal"      );
    championTokens.insert( "champion_BlueToken"      , "Retaliating" );
    championTokens.insert( "champion_BronzeToken"    , "Tough"       );
    championTokens.insert( "champion_CyanToken"      , "Vortex"      );
    championTokens.insert( "champion_DarkGreenToken" , "Toxic"       );
    championTokens.insert( "champion_DarkRedToken"   , "Reanimating" );
    championTokens.insert( "champion_GoldToken"      , "Golden"      );
    championTokens.insert( "champion_GreenToken"     , "Phasing"     );
    championTokens.insert( "champion_GreyToken"      , "Nimble"      );
    championTokens.insert( "champion_IndigoToken"    , "Fissile"     );
    championTokens.insert( "champion_OrangeToken"    , "Exploding"   );
    championTokens.insert( "champion_PinkToken"      , "Healer"      );
    championTokens.insert( "champion_RedToken"       , "Sturdy"      );
    championTokens.insert( "champion_SilverToken"    , "Reflective"  );
    championTokens.insert( "champion_VioletToken"    , "Relentless"  );
    championTokens.insert( "champion_WhiteToken"     , "Restraining" );
    championTokens.insert( "champion_YellowToken"    , "Fast"        );
  }

  private
  void fillSlaveActors()
  {
    _slaveActors.insert( "HeadshotTargetZombie"        , "1" );
    _slaveActors.insert( "HeadshotTargetEliteZombie"   , "1" );
    _slaveActors.insert( "HeadshotTargetImp"           , "1" );
    _slaveActors.insert( "HeadshotTargetAngryImp"      , "1" );
    _slaveActors.insert( "HeadshotTargetNoble"         , "1" );
    _slaveActors.insert( "HeadshotTargetEliteNoble"    , "1" );
    _slaveActors.insert( "HeadshotTargetBossNoble"     , "1" );
    _slaveActors.insert( "HeadshotTargetArchvile"      , "1" );
    _slaveActors.insert( "HeadshotTargetEliteArchvile" , "1" );
    _slaveActors.insert( "HeadshotTargetRevenant"      , "1" );
    _slaveActors.insert( "HeadshotTargetEliteRevenant" , "1" );
    _slaveActors.insert( "HeadshotTargetMancubus"      , "1" );
    _slaveActors.insert( "HeadshotTargetSoulCommander" , "1" );
    _slaveActors.insert( "HeadshotTargetCacodemon"     , "1" );
    _slaveActors.insert( "HeadshotTargetPainElemental" , "1" );
    _slaveActors.insert( "HeadshotTargetDemon"         , "1" );
    _slaveActors.insert( "HeadshotTargetCyberdemon"    , "1" );
  }

  private
  void fillBlackList()
  {
    _blackList.insert( "m8f_aas_token"           , "1" );
    _blackList.insert( "AutoautosaveToken"       , "1" );
    _blackList.insert( "AutoautosaveAlertToken"  , "1" );
    _blackList.insert( "AutoautosaveAlerter"     , "1" );
    _blackList.insert( "AutoautosaveBossAlerter" , "1" );
    _blackList.insert( "UGGib_Corpse_Shootable"  , "1" );
    _blackList.insert( "VoidField"               , "1" );
    _blackList.insert( "Cow"                     , "1" );
    _blackList.insert( "WinterCow"               , "1" );
    _blackList.insert( "SpaceCow"                , "1" );
    _blackList.insert( "SpaceCowFloating"        , "1" );
    _blackList.insert( "CowboyCow"               , "1" );
    _blackList.insert( "MummyCow"                , "1" );
    _blackList.insert( "ShieldDefense"           , "1" );
    _blackList.insert( "ShieldDefense2"          , "1" );
  }

  private Dictionary _slaveActors;
  private Dictionary _blackList;

} // class ts_Data
