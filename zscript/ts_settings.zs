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

class ts_Settings
{

  enum FrameStyles
  {
    FRAME_DISABLED,
    FRAME_SLASH,
    FRAME_DOTS,
    FRAME_LESS_GREATER,
    FRAME_GREATER_LESS,
    FRAME_BARS,
    FRAME_GRAPHIC,
    FRAME_GRAPHIC_RED,
  };

  enum BarsOnTargetPosition
  {
    ON_TARGET_DISABLED,
    ON_TARGET_ABOVE,
    ON_TARGET_BELOW,
  }

  static
  ts_Settings from()
  {
    let result = new("ts_Settings");
    result._player = players[consolePlayer];
    return result;
  }

  // n must be from [0, 11]
  int    colors         (int n) { checkInit(); return _colors[n].value(); }

  bool   showKillConfirmation() { checkInit(); return _showKillConfirmation.value(); }
  bool   namedConfirmation   () { checkInit(); return _namedConfirmation   .value(); }
  bool   isEnabled           () { checkInit(); return _isEnabled           .value(); }

  int    minHealth           () { checkInit(); return _minHealth           .value(); }
  double yStart              () { checkInit(); return _yStart              .value(); }
  double yOffset             () { checkInit(); return _yOffset             .value(); }
  bool   logScale            () { checkInit(); return _logScale            .value(); }
  bool   showBar             () { checkInit(); return _showBar             .value(); }
  bool   showName            () { checkInit(); return _showName            .value(); }
  bool   showNameAndTag      () { checkInit(); return _showNameAndTag      .value(); }
  int    showNums            () { checkInit(); return _showNums            .value(); }
  bool   showInfo            () { checkInit(); return _showInfo            .value(); }
  bool   showCorps           () { checkInit(); return _showCorps           .value(); }
  bool   crossOn             () { checkInit(); return _crossOn             .value(); }
  int    crossCol            () { checkInit(); return _crossCol            .value(); }
  int    nameCol             () { checkInit(); return _nameCol             .value(); }
  int    weakCol             () { checkInit(); return _weakCol             .value(); }
  bool   altHpCols           () { checkInit(); return _altHpCols           .value(); }
  bool   almDeadCr           () { checkInit(); return _almDeadCr           .value(); }
  int    crAlmDead           () { checkInit(); return _crAlmDead           .value(); }
  double crossOff            () { checkInit(); return _crossOff            .value(); }
  double topOff              () { checkInit(); return _topOff              .value(); }
  double botOff              () { checkInit(); return _botOff              .value(); }
  int    greenCr             () { checkInit(); return _greenCr             .value(); }
  int    redCr               () { checkInit(); return _redCr               .value(); }
  bool   showChampion        () { checkInit(); return _showChampion        .value(); }
  int    showObjects         () { checkInit(); return _showObjects         .value(); }
  int    showInternalNames   () { checkInit(); return _showInternalNames   .value(); }
  bool   showHidden          () { checkInit(); return _showHidden          .value(); }
  bool   showFriends         () { checkInit(); return _showFriends         .value(); }
  bool   showDormant         () { checkInit(); return _showDormant         .value(); }
  double crossScale          () { checkInit(); return _crossScale.value() ? _crossScale.value() : 1; }
  bool   hitConfirmation     () { checkInit(); return _hitConfirmation     .value(); }
  int    hitColor            () { checkInit(); return _hitColor            .value(); }
  double xAdjustment         () { checkInit(); return _xAdjustment         .value(); }
  bool   noCrossOnSlot1      () { checkInit(); return _noCrossOnSlot1      .value(); }
  int    frameStyle          () { checkInit(); return _frameStyle          .value(); }
  double frameScale          () { checkInit(); return _frameScale.value() ? _frameScale.value() : 1; }
  double frameSize           () { checkInit(); return _frameSize           .value(); }
  bool   showIdle            () { checkInit(); return _showIdle            .value(); }
  bool   hideInDarkness      () { checkInit(); return _hideInDarkness      .value(); }
  int    minimalLightLevel   () { checkInit(); return _minimalLightLevel   .value(); }
  double crossOpacity        () { checkInit(); return _crossOpacity        .value(); }
  double opacity             () { checkInit(); return _opacity             .value(); }
  double lengthMultiplier    () { checkInit(); return _lengthMultiplier    .value(); }
  int    barsOnTarget        () { checkInit(); return _barsOnTarget        .value(); }

  string pip                 () { checkInit(); return _pip                 .value(); }
  string emptyPip            () { checkInit(); return _emptyPip            .value(); }
  string fontName            () { checkInit(); return _fontName            .value(); }
  string crosshair           () { checkInit(); return _crosshair           .value(); }
  string crossTop            () { checkInit(); return _crossTop            .value(); }
  string crossBot            () { checkInit(); return _crossBot            .value(); }
  string crossFontName       () { checkInit(); return _crossFontName       .value(); }

  double getTextScale()     { return 0.5 / textScale(); }
  double getNewlineHeight() { return 0.03 * stepMult(); }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private double textScale() { checkInit(); return _textScale.value() ? _textScale.value() : 1; }
  private double stepMult () { checkInit(); return _stepMult.value(); }

  private
  void checkInit()
  {
    if (_isInitialized) { return; }
    _isInitialized = true;

    _showKillConfirmation = new("m8f_ts_BoolSetting"  ).init("m8f_ts_show_confirm"  , _player);
    _namedConfirmation    = new("m8f_ts_BoolSetting"  ).init("m8f_ts_named_confirm" , _player);
    _isEnabled            = new("m8f_ts_BoolSetting"  ).init("m8f_ts_enabled"       , _player);

    _minHealth            = new("m8f_ts_IntSetting"   ).init("m8f_ts_min_health"    , _player);
    _yStart               = new("m8f_ts_DoubleSetting").init("m8f_ts_y"             , _player);
    _yOffset              = new("m8f_ts_DoubleSetting").init("m8f_ts_y_offset"      , _player);
    _logScale             = new("m8f_ts_BoolSetting"  ).init("m8f_ts_bar_log_scale" , _player);
    _showBar              = new("m8f_ts_BoolSetting"  ).init("m8f_ts_show_bar"      , _player);
    _showName             = new("m8f_ts_BoolSetting"  ).init("m8f_ts_show_name"     , _player);
    _showNameAndTag       = new("m8f_ts_BoolSetting"  ).init("m8f_ts_show_name_tag" , _player);
    _showNums             = new("m8f_ts_IntSetting"   ).init("m8f_ts_show_numbers"  , _player);
    _showInfo             = new("m8f_ts_BoolSetting"  ).init("m8f_ts_show_info"     , _player);
    _showCorps            = new("m8f_ts_BoolSetting"  ).init("m8f_ts_show_corpses"  , _player);
    _showNoBlockmap       = new("m8f_ts_BoolSetting"  ).init("m8f_ts_show_noblockm" , _player);
    _crossOn              = new("m8f_ts_BoolSetting"  ).init("m8f_ts_crosshair_on"  , _player);
    _crossCol             = new("m8f_ts_IntSetting"   ).init("m8f_ts_def_color_crs" , _player);
    _nameCol              = new("m8f_ts_IntSetting"   ).init("m8f_ts_def_color_tag" , _player);
    _weakCol              = new("m8f_ts_IntSetting"   ).init("m8f_ts_def_cl_tag_wk" , _player);
    _altHpCols            = new("m8f_ts_BoolSetting"  ).init("m8f_ts_alt_hp_color"  , _player);
    _crAlmDead            = new("m8f_ts_IntSetting"   ).init("m8f_ts_cr_alm_dead"   , _player);
    _stepMult             = new("m8f_ts_DoubleSetting").init("m8f_ts_step_mult"     , _player);
    _almDeadCr            = new("m8f_ts_BoolSetting"  ).init("m8f_ts_alm_dead_cr"   , _player);
    _crossOff             = new("m8f_ts_DoubleSetting").init("m8f_ts_cross_offset"  , _player);
    _topOff               = new("m8f_ts_DoubleSetting").init("m8f_ts_top_offset"    , _player);
    _botOff               = new("m8f_ts_DoubleSetting").init("m8f_ts_bot_offset"    , _player);
    _greenCr              = new("m8f_ts_IntSetting"   ).init("m8f_ts_green_color"   , _player);
    _redCr                = new("m8f_ts_IntSetting"   ).init("m8f_ts_red_color"     , _player);
    _showChampion         = new("m8f_ts_BoolSetting"  ).init("m8f_ts_show_champion" , _player);
    _showObjects          = new("m8f_ts_IntSetting"   ).init("m8f_ts_show_objects"  , _player);
    _showInternalNames    = new("m8f_ts_IntSetting"   ).init("m8f_class_as_tag"     , _player);
    _showHidden           = new("m8f_ts_BoolSetting"  ).init("m8f_ts_show_hidden"   , _player);
    _showFriends          = new("m8f_ts_BoolSetting"  ).init("m8f_ts_show_friends"  , _player);
    _showDormant          = new("m8f_ts_BoolSetting"  ).init("m8f_ts_show_dormant"  , _player);
    _crossScale           = new("m8f_ts_DoubleSetting").init("m8f_ts_cross_scale"   , _player);
    _hitConfirmation      = new("m8f_ts_BoolSetting"  ).init("m8f_ts_hit_confirm"   , _player);
    _hitColor             = new("m8f_ts_IntSetting"   ).init("m8f_ts_hit_color"     , _player);
    _textScale            = new("m8f_ts_DoubleSetting").init("m8f_ts_text_scale"    , _player);
    _xAdjustment          = new("m8f_ts_DoubleSetting").init("m8f_ts_x_adjustment"  , _player);
    _noCrossOnSlot1       = new("m8f_ts_BoolSetting"  ).init("m8f_ts_no_cross_on_1" , _player);
    _frameStyle           = new("m8f_ts_IntSetting"   ).init("m8f_ts_frame_style"   , _player);
    _frameScale           = new("m8f_ts_DoubleSetting").init("m8f_ts_frame_scale"   , _player);
    _frameSize            = new("m8f_ts_DoubleSetting").init("m8f_ts_frame_size"    , _player);
    _showIdle             = new("m8f_ts_BoolSetting"  ).init("m8f_ts_show_idle"     , _player);
    _hideInDarkness       = new("m8f_ts_BoolSetting"  ).init("m8f_ts_hide_in_dark"  , _player);
    _minimalLightLevel    = new("m8f_ts_IntSetting"   ).init("m8f_ts_light_level"   , _player);
    _crossOpacity         = new("m8f_ts_DoubleSetting").init("m8f_ts_cr_opacity"    , _player);
    _opacity              = new("m8f_ts_DoubleSetting").init("m8f_ts_opacity"       , _player);
    _lengthMultiplier     = new("m8f_ts_DoubleSetting").init("m8f_ts_length_mult"   , _player);
    _barsOnTarget         = new("m8f_ts_IntSetting"   ).init("m8f_ts_on_target"     , _player);

    _pip                  = new("m8f_ts_StringSetting").init("m8f_ts_pip"           , _player);
    _emptyPip             = new("m8f_ts_StringSetting").init("m8f_ts_empty_pip"     , _player);
    _fontName             = new("m8f_ts_StringSetting").init("m8f_ts_font"          , _player);
    _crosshair            = new("m8f_ts_StringSetting").init("m8f_ts_crosshair"     , _player);
    _crossTop             = new("m8f_ts_StringSetting").init("m8f_ts_cross_top"     , _player);
    _crossBot             = new("m8f_ts_StringSetting").init("m8f_ts_cross_bottom"  , _player);
    _crossFontName        = new("m8f_ts_StringSetting").init("m8f_ts_cr_font"       , _player);

    _colors[ 0]           = new("m8f_ts_IntSetting"   ).init("m8f_ts_cr_0"          , _player);
    _colors[ 1]           = new("m8f_ts_IntSetting"   ).init("m8f_ts_cr_1"          , _player);
    _colors[ 2]           = new("m8f_ts_IntSetting"   ).init("m8f_ts_cr_2"          , _player);
    _colors[ 3]           = new("m8f_ts_IntSetting"   ).init("m8f_ts_cr_3"          , _player);
    _colors[ 4]           = new("m8f_ts_IntSetting"   ).init("m8f_ts_cr_4"          , _player);
    _colors[ 5]           = new("m8f_ts_IntSetting"   ).init("m8f_ts_cr_5"          , _player);
    _colors[ 6]           = new("m8f_ts_IntSetting"   ).init("m8f_ts_cr_6"          , _player);
    _colors[ 7]           = new("m8f_ts_IntSetting"   ).init("m8f_ts_cr_7"          , _player);
    _colors[ 8]           = new("m8f_ts_IntSetting"   ).init("m8f_ts_cr_8"          , _player);
    _colors[ 9]           = new("m8f_ts_IntSetting"   ).init("m8f_ts_cr_9"          , _player);
    _colors[10]           = new("m8f_ts_IntSetting"   ).init("m8f_ts_cr_10"         , _player);
    _colors[11]           = new("m8f_ts_IntSetting"   ).init("m8f_ts_cr_11"         , _player);
  }

  private PlayerInfo     _player;
  private transient bool _isInitialized;

  private m8f_ts_BoolSetting   _showKillConfirmation;
  private m8f_ts_BoolSetting   _namedConfirmation;
  private m8f_ts_BoolSetting   _isEnabled;

  private m8f_ts_IntSetting    _minHealth;
  private m8f_ts_DoubleSetting _yStart;
  private m8f_ts_DoubleSetting _yOffset;
  private m8f_ts_BoolSetting   _logScale;
  private m8f_ts_BoolSetting   _showBar;
  private m8f_ts_BoolSetting   _showName;
  private m8f_ts_BoolSetting   _showNameAndTag;
  private m8f_ts_IntSetting    _showNums;
  private m8f_ts_BoolSetting   _showInfo;
  private m8f_ts_BoolSetting   _showCorps;
  private m8f_ts_BoolSetting   _showNoBlockmap;
  private m8f_ts_BoolSetting   _crossOn;
  private m8f_ts_IntSetting    _crossCol;
  private m8f_ts_IntSetting    _nameCol;
  private m8f_ts_IntSetting    _weakCol;
  private m8f_ts_BoolSetting   _altHpCols;
  private m8f_ts_DoubleSetting _stepMult;
  private m8f_ts_BoolSetting   _almDeadCr;
  private m8f_ts_IntSetting    _crAlmDead;
  private m8f_ts_DoubleSetting _crossOff;
  private m8f_ts_DoubleSetting _topOff;
  private m8f_ts_DoubleSetting _botOff;
  private m8f_ts_IntSetting    _greenCr;
  private m8f_ts_IntSetting    _redCr;
  private m8f_ts_BoolSetting   _showChampion;
  private m8f_ts_IntSetting    _showObjects;
  private m8f_ts_IntSetting    _showInternalNames;
  private m8f_ts_BoolSetting   _showHidden;
  private m8f_ts_BoolSetting   _showFriends;
  private m8f_ts_BoolSetting   _showDormant;
  private m8f_ts_DoubleSetting _crossScale;
  private m8f_ts_BoolSetting   _hitConfirmation;
  private m8f_ts_IntSetting    _hitColor;
  private m8f_ts_DoubleSetting _textScale;
  private m8f_ts_DoubleSetting _xAdjustment;
  private m8f_ts_BoolSetting   _noCrossOnSlot1;
  private m8f_ts_IntSetting    _frameStyle;
  private m8f_ts_DoubleSetting _frameScale;
  private m8f_ts_DoubleSetting _frameSize;
  private m8f_ts_BoolSetting   _showIdle;
  private m8f_ts_BoolSetting   _hideInDarkness;
  private m8f_ts_IntSetting    _minimalLightLevel;
  private m8f_ts_DoubleSetting _crossOpacity;
  private m8f_ts_DoubleSetting _opacity;
  private m8f_ts_DoubleSetting _lengthMultiplier;
  private m8f_ts_IntSetting    _barsOnTarget;

  private m8f_ts_StringSetting _pip;
  private m8f_ts_StringSetting _emptyPip;
  private m8f_ts_StringSetting _fontName;
  private m8f_ts_StringSetting _crosshair;
  private m8f_ts_StringSetting _crossTop;
  private m8f_ts_StringSetting _crossBot;
  private m8f_ts_StringSetting _crossFontName;

  private m8f_ts_IntSetting    _colors[12];

} // class ts_Settings
