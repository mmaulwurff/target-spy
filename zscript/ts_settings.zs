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

class ts_UiSettings ui
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

  enum ShowNameOptions
  {
    NAME_DISABLED,
    NAME_TAG,
    NAME_CLASS,
    NAME_TAG_AND_CLASS,
    NAME_TAG_AND_CLASS_IF_DIFFERENT,
  }

  static
  ts_UiSettings from()
  {
    let result = new("ts_UiSettings");
    result.initialize();
    return result;
  }

  /// i must be from [0, 11]
  int    colors         (int i) { return _colors[i].getInt(); }

  bool   showKillConfirmation() { return _showKillConfirmation.getInt(); }
  bool   namedConfirmation   () { return _namedConfirmation   .getInt(); }
  bool   isEnabled           () { return _isEnabled           .getInt(); }

  int    minHealth           () { return _minHealth           .getInt(); }
  double yStart              () { return _yStart              .getFloat(); }
  double yOffset             () { return _yOffset             .getFloat(); }
  bool   logScale            () { return _logScale            .getInt(); }
  bool   showBar             () { return _showBar             .getInt(); }
  int    showName            () { return _showName            .getInt(); }
  int    showNumbers         () { return _showNumbers         .getInt(); }
  bool   showInfo            () { return _showInfo            .getInt(); }
  bool   showCorps           () { return _showCorps           .getInt(); }
  bool   crossOn             () { return _crossOn             .getInt(); }
  int    crosshairColor      () { return _crosshairColor      .getInt(); }
  int    nameCol             () { return _nameCol             .getInt(); }
  int    weakCol             () { return _weakCol             .getInt(); }
  bool   altHpCols           () { return _altHpCols           .getInt(); }
  bool   almDeadCr           () { return _almDeadCr           .getInt(); }
  int    crAlmDead           () { return _crAlmDead           .getInt(); }
  bool   isBackgroundEnabled () { return _isBackgroundEnabled .getInt(); }

  int    crossTopOffset      () { return _crossTopOffset      .getInt(); }
  int    crossMiddleOffset   () { return _crossMiddleOffset   .getInt(); }
  int    crossBottomOffset   () { return _crossBottomOffset   .getInt(); }
  int    xAdjustment         () { return _xAdjustment         .getInt(); }

  int    greenCr             () { return _greenCr             .getInt(); }
  int    redCr               () { return _redCr               .getInt(); }

  double crossScale          () { return notZero(_crossScale.getFloat()); }
  double crossOpacity        () { return _crossOpacity        .getFloat(); }

  bool   hitConfirmation     () { return _hitConfirmation     .getInt(); }
  int    hitColor            () { return _hitColor            .getInt(); }

  bool   noCrossOnSlot1      () { return _noCrossOnSlot1      .getInt(); }
  bool   isCrossTargetColor  () { return _isCrossTargetColor  .getInt(); }

  int    frameStyle          () { return _frameStyle          .getInt(); }
  double frameScale          () { return notZero(_frameScale.getFloat()); }
  double frameSize           () { return _frameSize           .getFloat(); }

  double opacity             () { return _opacity             .getFloat(); }
  double lengthMultiplier    () { return _lengthMultiplier    .getFloat(); }

  string pip                 () { return _pip                 .getString(); }
  string emptyPip            () { return _emptyPip            .getString(); }
  string fontName            () { return _fontName            .getString(); }
  string crosshair           () { return _crosshair           .getString(); }
  string crossTop            () { return _crossTop            .getString(); }
  string crossBot            () { return _crossBot            .getString(); }
  string crossFontName       () { return _crossFontName       .getString(); }

  double getTextScale        () { return notZero(_textScale.getFloat()); }

  int barsOnTarget()
  {
    double yStart = _yStart.getFloat();
    if (yStart == -2) return ON_TARGET_ABOVE;
    if (yStart == -1) return ON_TARGET_BELOW;
    return ON_TARGET_DISABLED;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private static
  double notZero(double value)
  {
    return value ? value : 1;
  }

  private void initialize()
  {
    _showKillConfirmation = makeCvar("m8f_ts_show_confirm");
    _namedConfirmation    = makeCvar("m8f_ts_named_confirm");
    _isEnabled            = makeCvar("m8f_ts_enabled");

    _minHealth            = makeCvar("m8f_ts_min_health");
    _yStart               = makeCvar("m8f_ts_y");
    _yOffset              = makeCvar("m8f_ts_y_offset");
    _logScale             = makeCvar("m8f_ts_bar_log_scale");
    _showBar              = makeCvar("m8f_ts_show_bar");
    _showName             = makeCvar("ts_name");
    _showNumbers          = makeCvar("m8f_ts_show_numbers");
    _showInfo             = makeCvar("m8f_ts_show_info");
    _showCorps            = makeCvar("m8f_ts_show_corpses");
    _crossOn              = makeCvar("m8f_ts_crosshair_on");
    _crosshairColor       = makeCvar("m8f_ts_def_color_crs");
    _nameCol              = makeCvar("m8f_ts_def_color_tag");
    _weakCol              = makeCvar("m8f_ts_def_cl_tag_wk");
    _altHpCols            = makeCvar("m8f_ts_alt_hp_color");

    _crAlmDead            = makeCvar("m8f_ts_cr_alm_dead");
    _almDeadCr            = makeCvar("m8f_ts_alm_dead_cr");

    _crossTopOffset       = makeCvar("ts_cross_top_offset");
    _crossMiddleOffset    = makeCvar("ts_cross_middle_offset");
    _crossBottomOffset    = makeCvar("ts_cross_bottom_offset");
    _xAdjustment          = makeCvar("ts_cross_x_adjustment");

    _greenCr              = makeCvar("m8f_ts_green_color");
    _redCr                = makeCvar("m8f_ts_red_color");

    _crossScale           = makeCvar("m8f_ts_cross_scale");
    _crossOpacity         = makeCvar("m8f_ts_cr_opacity");

    _hitConfirmation      = makeCvar("m8f_ts_hit_confirm");
    _hitColor             = makeCvar("m8f_ts_hit_color");

    _textScale            = makeCvar("m8f_ts_text_scale");
    _noCrossOnSlot1       = makeCvar("m8f_ts_no_cross_on_1");
    _isCrossTargetColor   = makeCvar("ts_cross_show_target");

    _frameStyle           = makeCvar("m8f_ts_frame_style");
    _frameScale           = makeCvar("m8f_ts_frame_scale");
    _frameSize            = makeCvar("m8f_ts_frame_size");

    _opacity              = makeCvar("m8f_ts_opacity");
    _lengthMultiplier     = makeCvar("m8f_ts_length_mult");

    _pip                  = makeCvar("m8f_ts_pip");
    _emptyPip             = makeCvar("m8f_ts_empty_pip");
    _fontName             = makeCvar("m8f_ts_font");
    _crosshair            = makeCvar("m8f_ts_crosshair");
    _crossTop             = makeCvar("m8f_ts_cross_top");
    _crossBot             = makeCvar("m8f_ts_cross_bottom");
    _crossFontName        = makeCvar("m8f_ts_cr_font");

    _isBackgroundEnabled  = makeCvar("ts_background");

    for (int i = 0; i < 12; ++i)
    {
      _colors[i] = makeCvar(string.format("m8f_ts_cr_%d", i));
    }
  }

  private static
  Cvar makeCvar(string cvarName)
  {
    return Cvar.getCvar(cvarName, players[consolePlayer]);
  }

  private Cvar _showKillConfirmation;
  private Cvar _namedConfirmation;
  private Cvar _isEnabled;

  private Cvar _minHealth;
  private Cvar _yStart;
  private Cvar _yOffset;
  private Cvar _logScale;
  private Cvar _showBar;
  private Cvar _showName;
  private Cvar _showNumbers;
  private Cvar _showInfo;
  private Cvar _showCorps;
  private Cvar _crossOn;
  private Cvar _crosshairColor;
  private Cvar _nameCol;
  private Cvar _weakCol;
  private Cvar _altHpCols;
  private Cvar _almDeadCr;
  private Cvar _crAlmDead;

  private Cvar _crossMiddleOffset;
  private Cvar _crossTopOffset;
  private Cvar _crossBottomOffset;

  private Cvar _greenCr;
  private Cvar _redCr;
  private Cvar _isBackgroundEnabled;

  private Cvar _crossScale;
  private Cvar _crossOpacity;

  private Cvar _hitConfirmation;
  private Cvar _hitColor;

  private Cvar _textScale;
  private Cvar _xAdjustment;
  private Cvar _noCrossOnSlot1;
  private Cvar _isCrossTargetColor;

  private Cvar _frameStyle;
  private Cvar _frameScale;
  private Cvar _frameSize;

  private Cvar _opacity;
  private Cvar _lengthMultiplier;

  private Cvar _pip;
  private Cvar _emptyPip;
  private Cvar _fontName;
  private Cvar _crosshair;
  private Cvar _crossTop;
  private Cvar _crossBot;
  private Cvar _crossFontName;

  private Cvar _colors[12];

} // class ts_UiSettings

class ts_PlaySettings
{

  static
  ts_PlaySettings from()
  {
    let result = new("ts_PlaySettings");
    result.initialize();
    return result;
  }

  int    showObjects         () { return _showObjects         .getInt(); }
  bool   hideInDarkness      () { return _hideInDarkness      .getInt(); }
  bool   showHidden          () { return _showHidden          .getInt(); }
  bool   showFriends         () { return _showFriends         .getInt(); }
  bool   showDormant         () { return _showDormant         .getInt(); }
  bool   showIdle            () { return _showIdle            .getInt(); }
  int    minimalLightLevel   () { return _minimalLightLevel   .getInt(); }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void initialize()
  {
    _showObjects          = makeCvar("m8f_ts_show_objects");
    _hideInDarkness       = makeCvar("m8f_ts_hide_in_dark");
    _showHidden           = makeCvar("m8f_ts_show_hidden");
    _showFriends          = makeCvar("m8f_ts_show_friends");
    _showDormant          = makeCvar("m8f_ts_show_dormant");
    _showIdle             = makeCvar("m8f_ts_show_idle");
    _minimalLightLevel    = makeCvar("m8f_ts_light_level");
  }

  private static
  Cvar makeCvar(string cvarName)
  {
    return Cvar.getCvar(cvarName, players[consolePlayer]);
  }

  private Cvar _showObjects;
  private Cvar _hideInDarkness;
  private Cvar _showHidden;
  private Cvar _showFriends;
  private Cvar _showDormant;
  private Cvar _showIdle;
  private Cvar _minimalLightLevel;

} // class ts_PlaySettings
