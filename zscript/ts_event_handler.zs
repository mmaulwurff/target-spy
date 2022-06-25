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

/**
 * Target Spy will call getStringUI and getDouble on any service that has
 * "TargetSpyService" in its name.
 *
 * Object argument is Target Spy target, it is guaranteed to be a non-null Actor.
 *
 * getStringUI is expected to return additional information about the target for "text" request.
 * getStringUI is expected to return a font for the target for "font" request.
 * getDoubleUI is expected to return text scale relative to user-configured text scale.
 * getInt is expected to return target color, or Font.CR_UNDEFINED if none specified.
 */
//*
class ts_ExampleTargetSpyService : Service
{
  override
  string getStringUI(string request, string _1, int _2, double _3, Object targetObject)
  {
    let target = Actor(targetObject);

    if (request == "text")
      return (target is "Zombieman") ? "\cdZombo\c- Bob" : "Some kind of thing";

    if (request == "font")
      return (target is "Zombieman") ? "BigFont" : "";

    return "";
  }

  override
  double getDoubleUI(string _, string _1, int _2, double _3, Object targetObject)
  {
    let target = Actor(targetObject);
    if (target is "Zombieman") return 1.0;
    return 2.0;
  }

  override
  int getInt(string _, string _1, int _2, double _3, Object targetObject)
  {
    return Font.CR_UNDEFINED;
  }
}
//*/

struct ts_View
{
  Actor target;
  bool  isShowingHealth;
  int   targetHealth;
  int   targetMaxHealth;
  bool  isTargetDead;
  int   customTargetColor;
  int   percent;
}

class ts_EventHandler : EventHandler
{

  override
  void playerEntered(PlayerEvent event)
  {
    if (ts_Game.isTitlemap())
    {
      destroy();
      return;
    }

    if (event.playerNumber != consolePlayer) return;

    _settings       = ts_Settings.from();
    _api            = ts_Api.from();
    _lastTargetInfo = ts_LastTargetInfo.from();
    _translator     = NULL;
    _data           = ts_Data.from();

    initService();
  }

  override
  void worldTick()
  {
    if (!_isInitialized) { initialize(); }

    if (  automapActive
       || players[consolePlayer].mo == NULL
       || !_settings.isEnabled()
       )
    {
      return;
    }

    prepareProjection();

    _view.target            = getTarget();
    _view.targetMaxHealth   = ts_ActorInfo.getActorMaxHealth(_view.target);
    _view.isShowingHealth   = (_view.targetMaxHealth != 0);
    _view.targetHealth      = (_view.target == NULL) ? 0 : _view.target.health;
    _view.isTargetDead      = _view.targetHealth < 1;
    _view.customTargetColor = readCustomColor(_view.target);
    _view.percent           = _view.isShowingHealth
      ? clamp(_view.targetHealth * 10 / _view.targetMaxHealth, 0, 11)
      : 10;

    bool hasTarget = (_view.target != NULL);

    _api.setHasTarget(hasTarget);
    _api.setIsFriendlyTarget(hasTarget && _view.target.bFRIENDLY);

    if (hasTarget)
    {
      setLastTarget(_view.target);
    }
  }

  override
  void worldThingDied(WorldEvent event)
  {
    if (event == NULL) return;

    Actor died = event.thing;
    if (died == NULL) return;

    if (isLastTargetExisting() && _lastTargetInfo.a == died)
    {
      _lastTargetInfo.killTime = level.time;
      _lastTargetInfo.killName = _lastTargetInfo.name;
    }
  }

  override
  void worldThingDamaged(WorldEvent event)
  {
    if (event == NULL) return;

    Actor damagedThing = event.thing;
    if (damagedThing == NULL) return;

    if (isLastTargetExisting() && _lastTargetInfo.a == damagedThing)
    {
      _lastTargetInfo.hurtTime = level.time;
    }
  }

  override
  void renderOverlay(RenderEvent event)
  {
    if (  !_isInitialized
       || !_isPrepared
       || automapActive
       || players[consolePlayer].mo == NULL
       || !_settings.isEnabled()
       )
    {
      return;
    }

    Actor target          = _view.target;
    int   targetMaxHealth = _view.targetMaxHealth;
    bool  isShowingHealth = _view.isShowingHealth;
    int   targetHealth    = _view.targetHealth;
    bool  isTargetDead    = _view.isTargetDead;
    int   customColor     = _view.customTargetColor;

    bool    isAbove        = (_settings.barsOnTarget() == ts_Settings.ON_TARGET_ABOVE);
    Font    font           = Font.getFont(_settings.fontName());
    double  textScale      = _settings.getTextScale();
    int     crosshairColor = _settings.crosshairColor();

    Vector2 xy = toAbsolute(getRelativeXY(target, event, isAbove));
    int tagColor;
    if (customColor != Font.CR_UNDEFINED) { tagColor = customColor; }
    else if (targetMaxHealth < 100)       { tagColor = _settings.weakCol(); }
    else                                  { tagColor = _settings.nameCol(); }

    if (_settings.barsOnTarget() == ts_Settings.ON_TARGET_DISABLED)
    {
      xy.y = drawKillConfirmed(xy, font);
    }
    else
    {
      drawKillConfirmed(toAbsolute(getDefaultRelativeXY()), font);
    }

    if (target == NULL)
    {
      drawCrosshairs(target, crosshairColor);
      return;
    }

    if (targetMaxHealth < _settings.minHealth() && targetMaxHealth != 0)
    {
      drawCrosshairs(target, crosshairColor);
      return; // not worth showing
    }

    if (isTargetDead && !_settings.showCorps())
    {
      drawCrosshairs(target, crosshairColor);
      return;
    }

    int targetColor = _settings.colors(_view.percent);
    if (targetHealth < 35 && _settings.almDeadCr()) targetColor = _settings.crAlmDead();
    if (isTargetDead)                               targetColor = _settings.crAlmDead();

    drawCrosshairs(target, _settings.isCrossTargetColor() ? targetColor : crosshairColor);

    double opacity = _settings.opacity();
    bool   isBackgroundEnabled = _settings.isBackgroundEnabled();

    if (_settings.showBar() && isShowingHealth)
    {
      string hpBar = ts_String.makeHpBar( targetHealth
                                        , targetMaxHealth
                                        , _settings.logScale()
                                        , _settings.altHpCols()
                                        , _settings.greenCr()
                                        , _settings.redCr()
                                        , _settings.lengthMultiplier()
                                        , _settings.pip()
                                        , _settings.emptyPip()
                                        );
      xy.y += drawText(hpBar, targetColor, textScale, xy, font, opacity, isBackgroundEnabled);
    }

    int nameColor = tagColor;
    if (isTargetDead) { nameColor = targetColor; }

    if (_settings.showName())
    {
      string targetName = getTargetName(target);
      targetName = enableExtendedColorCode(targetName);

      if (isTargetDead)
      {
        targetName = string.format("Remains of %s", targetName);
        nameColor  = targetColor;
      }

      xy.y += drawText(targetName, nameColor, textScale, xy, font, opacity, isBackgroundEnabled);

      if (_settings.showNameAndTag() && target.getClassName() != targetName)
      {
        xy.y += drawText( target.getClassName()
                        , nameColor
                        , textScale
                        , xy
                        , font
                        , opacity
                        , isBackgroundEnabled
                        );
      }
    }

    if (_settings.showInfo())
    {
      string targetFlags = ts_ActorInfo.getTargetFlags(target);
      if (targetFlags.length() > 0)
      {
        xy.y += drawText(targetFlags, nameColor, textScale, xy, font, opacity, isBackgroundEnabled);
      }
    }

    if (isShowingHealth && (_settings.showNumbers() != 0))
    {
      string healthString = makeHealthString(targetHealth, targetMaxHealth);
      int    armor        = target.countInv("BasicArmor");

      if (armor)
      {
        healthString.appendFormat(" Armor: %d", armor);
      }

      xy.y += drawText( healthString
                      , targetColor
                      , textScale
                      , xy
                      , font
                      , opacity
                      , isBackgroundEnabled
                      );
    }

    uint extraInformationServicesCount = _extraInformationServices.size();
    for (uint i = 0; i < extraInformationServicesCount; ++i)
    {
      Service targetService = _extraInformationServices[i];
      string extraText = targetService.getStringUI("text", objectArg: target);
      if (extraText.length() == 0) continue;

      string fontString = targetService.getStringUI("font", objectArg: target);
      Font extraTextFont = (fontString.length() == 0)  ? font : Font.getFont(fontString);

      double extraScale = targetService.getDoubleUI("", objectArg: target);
      xy.y += drawText( extraText
                      , nameColor
                      , textScale * extraScale
                      , xy
                      , extraTextFont
                      , opacity
                      , isBackgroundEnabled
                      );
    }

    if (_settings.frameStyle() != ts_Settings.FRAME_DISABLED)
    {
      drawFrame(event, target, targetColor);
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  int readCustomColor(Actor target)
  {
    if (target == NULL) return Font.CR_UNDEFINED;

    int result = Font.CR_UNDEFINED;
    uint extraInformationServicesCount = _extraInformationServices.size();
    for (uint i = 0; i < extraInformationServicesCount; ++i)
    {
      int customColor = _extraInformationServices[i].getInt("", objectArg: target);
      if (customColor != Font.CR_UNDEFINED) return customColor;
    }
    return result;
  }

  private ui
  Vector2 makeDrawPos(RenderEvent event, Actor target, double offset)
  {
    PlayerInfo player = players[consolePlayer];

    _projection.cacheResolution();
    _projection.cacheFov(player.fov);
    _projection.orientForRenderOverlay(event);
    _projection.beginProjection();

    _projection.projectWorldPos(target.pos + (0, 0, offset));

    ts_Le_Viewport viewport;
    viewport.fromHud();

    Vector2 drawPos = viewport.sceneToWindow(_projection.projectToNormal());

    return drawPos;
  }

  private ui
  void drawFrame(RenderEvent event, Actor target, int color)
  {
    PlayerInfo player = players[consolePlayer];
    Vector2 centerPos = makeDrawPos(event, target, target.height / 2.0);
    double   distance = player.mo.distance3D(target);
    if (distance == 0) return;

    double  height        = target.height;
    double  radius        = target.radius;
    double  zoomFactor    = abs(sin(player.fov));
    if (zoomFactor == 0) return;

    double  visibleRadius = radius * 2000.0 / distance / zoomFactor;
    double  visibleHeight = height * 1000.0 / distance / zoomFactor;

    let  settings         = _settings;
    let  f                = Font.getFont(settings.fontName());

    double  size       = settings.frameSize();
    double  halfWidth  = visibleRadius / 2.0 * size;
    double  halfHeight = visibleHeight / 2.0 * size;

    Vector2 left   = (centerPos.x - halfWidth, centerPos.y);
    Vector2 right  = (centerPos.x + halfWidth, centerPos.y);
    Vector2 top    = (centerPos.x, centerPos.y - halfHeight);
    Vector2 bottom = (centerPos.x, centerPos.y + halfHeight);

    Vector2 topLeft     = (left.x,  top.y);
    Vector2 topRight    = (right.x, top.y);
    Vector2 bottomLeft  = (left.x,  bottom.y);
    Vector2 bottomRight = (right.x, bottom.y);
    double  scale       = settings.frameScale();
    int     frameStyle  = settings.frameStyle();

    switch (frameStyle)
    {
      case settings.FRAME_DISABLED:
        break;

      case settings.FRAME_SLASH:
        drawText("/", color, scale, topLeft, f);
        drawText("/", color, scale, bottomRight, f);
        break;

      case settings.FRAME_DOTS:
        drawText(".", color, scale, topLeft, f);
        drawText(".", color, scale, topRight, f);
        drawText(".", color, scale, bottomLeft, f);
        drawText(".", color, scale, bottomRight, f);
        break;

      case settings.FRAME_LESS_GREATER:
        drawText("<", color, scale, left, f);
        drawText(">", color, scale, right, f);
        break;

      case settings.FRAME_GREATER_LESS:
        drawText(">", color, scale, left, f);
        drawText("<", color, scale, right, f);
        break;

      case settings.FRAME_BARS:
        drawText(".", color, scale, top, f);
        drawText("I", color, scale, left, f);
        drawText("I", color, scale, right, f);
        drawText(".", color, scale, bottom, f);
        break;

      case settings.FRAME_GRAPHIC:
      case settings.FRAME_GRAPHIC_RED:
        {
          let  frameName      = (frameStyle == settings.FRAME_GRAPHIC) ? "ts_frame" : "ts_framr";
          let  topLeftTex     = TexMan.checkForTexture(frameName                  , TexMan.TryAny);
          let  topRightTex    = TexMan.checkForTexture(frameName.."_top_right"    , TexMan.TryAny);
          let  bottomLeftTex  = TexMan.checkForTexture(frameName.."_bottom_left"  , TexMan.TryAny);
          let  bottomRightTex = TexMan.checkForTexture(frameName.."_bottom_right" , TexMan.TryAny);
          bool animate        = false;

          Screen.setClipRect( int(topLeft.x)
                            , int(topLeft.y)
                            , int(round(bottomRight.x - topLeft.x + 1))
                            , int(round(bottomRight.y - topLeft.y + 1))
                            );

          Screen.drawTexture(topLeftTex,     animate, topLeft.x,     topLeft.y    );
          Screen.drawTexture(topRightTex,    animate, topRight.x,    topRight.y   );
          Screen.drawTexture(bottomLeftTex,  animate, bottomLeft.x,  bottomLeft.y );
          Screen.drawTexture(bottomRightTex, animate, bottomRight.x, bottomRight.y);
          Screen.clearClipRect();
        }
        break;
    }
  }

  private static ui
  int drawText( string  text
              , int     color
              , double  scale
              , Vector2 absolutePosition
              , Font    font
              , double  opacity = 1.0
              , bool    isBackgroundEnabled = BackgroundDisabled
              )
  {
    int stringWidth  = int(round(scale * font.stringWidth(text)));
    int stringHeight = int(round(scale * font.getHeight()));
    int border       = int(round(stringHeight / 4 * scale));
    int border2      = border * 2;

    int x = int(round(absolutePosition.x)) - stringWidth  / 2;
    int y = int(round(absolutePosition.y));

    if (isBackgroundEnabled)
    {
      Screen.dim("000000", 0.5, x - border, y - border, stringWidth + border2, stringHeight + border2);
    }

    Screen.drawText( font
                   , color
                   , x
                   , y
                   , text
                   , DTA_ScaleX      , scale
                   , DTA_ScaleY      , scale
                   , DTA_Alpha       , opacity
                   );

    return stringHeight + border2;
  }

  private static ui
  Vector2 toAbsolute(Vector2 relativePosition)
  {
    return (relativePosition.x * screen.getWidth(), relativePosition.y * screen.getHeight());
  }

  private
  void setLastTarget(Actor newLastTarget)
  {
    if (!isLastTargetExisting()) return;

    _lastTargetInfo.a    = newLastTarget;
    _lastTargetInfo.name = getTargetName(newLastTarget);
    _lastTargetInfo.name = enableExtendedColorCode(_lastTargetInfo.name);
  }

  private play
  bool isSlot1Weapon() const
  {
    PlayerInfo player = players[consolePlayer];
    Weapon w = player.readyWeapon;
    if (w == NULL) return true;

    int located;
    int slot;
    int priority;
    [located, slot, priority] = player.weapons.locateWeapon(w.getClassName());
    return (slot == 1);
  }

  private play
  bool isLastTargetExisting() const
  {
    return _lastTargetInfo != NULL;
  }

  private ui
  void drawCrosshairs(Actor target, int crosshairColor)
  {
    if (!_settings.crossOn()) return;
    if (_settings.noCrossOnSlot1() && isSlot1Weapon()) return;

    if (_settings.hitConfirmation()
        && isLastTargetExisting()
        && _lastTargetInfo.hurtTime != -1
        && (level.time < _lastTargetInfo.hurtTime + 10))
    {
      crosshairColor = _settings.hitColor();
    }

    double opacity = _settings.crossOpacity();
    double scale   = _settings.crossScale();
    Font   aFont   = Font.getFont(_settings.crossFontName());

    if (crosshairgrow) scale *= StatusBar.CrosshairSize;

    double baseCenterY     = readY(aFont, scale) - aFont.getHeight() / 2;
    double topBottomShift  = 0.02 * Screen.getHeight();
    double crosshairX      = 0.5  * Screen.getWidth() + _settings.xAdjustment();

    Vector2 topPosition    = (crosshairX, baseCenterY - topBottomShift + _settings.crossTopOffset());
    Vector2 centerPosition = (crosshairX, baseCenterY                  + _settings.crossMiddleOffset());
    Vector2 bottomPosition = (crosshairX, baseCenterY + topBottomShift + _settings.crossBottomOffset());

    drawText(_settings.crossTop(),  crosshairColor, scale, topPosition,    aFont, opacity);
    drawText(_settings.crosshair(), crosshairColor, scale, centerPosition, aFont, opacity);
    drawText(_settings.crossBot(),  crosshairColor, scale, bottomPosition, aFont, opacity);
  }

  private ui
  Vector2 getDefaultRelativeXY()
  {
    Vector2 result;
    result.x = 0.5;
    result.y = _settings.yStart() + _settings.yOffset();
    return result;
  }

  private ui
  Vector2 getRelativeXY(Actor target, RenderEvent event, bool isAbove)
  {
    if (target == NULL || !_settings.barsOnTarget()) return getDefaultRelativeXY();

    double y = isAbove
             ? target.height * 1.2
             : -5;
    Vector2 centerPos = makeDrawPos(event, target, y);
    Vector2 result    = ( centerPos.x / Screen.getWidth()
                        , clamp(centerPos.y / Screen.getHeight(), 0.1, 0.9)
                        );
    return result;
  }

  private ui
  string makeHealthString(int targetHealth, int targetMaxHealth)
  {
    switch (_settings.showNumbers())
    {
    case 1: return string.format("%d/%d", targetHealth, targetMaxHealth);
    case 2: return string.format("%d", targetHealth);

    case 3:
    {
      int percent100 = (targetMaxHealth == 0)
        ? 100
        : int(round(targetHealth * 100.0 / targetMaxHealth));
      return string.format("%d%%", percent100);
    }

    case 4:
    {
      double percent100dot00 = (targetMaxHealth == 0)
        ? 100
        : targetHealth * 100.0 / targetMaxHealth;
      return string.format("%.2f%%", percent100dot00);
    }
    }

    Console.printf("Unknown settings.showNumbers() result: %d", _settings.showNumbers());
    return "";
  }

  private ui
  double drawKillConfirmed(Vector2 xy, Font font)
  {
    if (!_settings.showKillConfirmation()) return xy.y;

    if (!isLastTargetExisting() || _lastTargetInfo.killTime == -1) return xy.y;

    if (level.time < _lastTargetInfo.killTime + 35 * 1)
    {
      double scale     = _settings.getTextScale();
      double opacity   = _settings.opacity();
      int    nameColor = _settings.nameCol();
      bool   isBackgroundEnabled = _settings.isBackgroundEnabled();
      string text = (_settings.namedConfirmation())
        ? _lastTargetInfo.killName .. " killed"
        : "Kill Confirmed";

      xy.y += drawText(text, nameColor, scale, xy, font, opacity, isBackgroundEnabled);
    }

    return xy.y;
  }

  private
  Actor getTarget()
  {
    PlayerInfo player = players[consolePlayer];
    if (player.mo == NULL) return NULL;

    // try an easy way to get a target (also works with autoaim)
    Actor target   = _translator.aimTargetWrapper(player.mo);
    let   settings = _settings;

    // if target is not found by easy way, try the difficult way
    if (target == NULL)
    {
      target = _translator.lineAttackTargetWrapper(player.mo, player.viewheight);
    }

    if (target == NULL && settings.showObjects() > 1)
    {
      target = _translator.aimLineAttackWrapper(player.mo);
    }

    if (target == NULL && settings.showObjects() > 3)
    {
      target = _translator.lineAttackNoBlockmapWrapper(player.mo, player.viewheight);
    }

    // give up
    if (target == NULL) return NULL;

    // target is found

    // check sector lighting
    if (settings.hideInDarkness())
    {
      bool noLightAmplifier = (player.mo.findInventory("PowerLightAmp") == NULL)
        && (player.mo.findInventory("PowerInvulnerable") == NULL);
      if (noLightAmplifier)
      {
        Sector targetSector = target.curSector;
        int    lightLevel   = targetSector.lightLevel;
        if (lightLevel < settings.minimalLightLevel()) return NULL;
      }
    }

    string targetClass   = target.getClassName();
    bool   targetIsSlave = _data.slaveActorsContain(targetClass);
    if (targetIsSlave)
    {
      target      = target.master;
      targetClass = target.getClassName();
    }

    bool isInBlackList = _data.blackListContains(targetClass);
    if (isInBlackList) return NULL;

    if (target.bIsMonster)
    {
      bool targetIsHidden = (target.bShadow || target.bStealth);
      if (!settings.showHidden()  && targetIsHidden)   return NULL;
      if (!settings.showFriends() && target.bFriendly) return NULL;
      if (!settings.showDormant() && target.bDormant)  return NULL;
      if (!settings.showIdle()    && ts_ActorInfo.isIdle(target)) return NULL;
    }
    else // not monsters
    {
      if (target.player) return target;

      switch (settings.showObjects())
      {
        case 0: return NULL;
        case 1:
          if (target.bShootable) return target;
          else                   return NULL;
        case 2:
          if (target.bShootable || target is "Inventory") return target;
          else                                            return NULL;
        case 3:
          return target;
      }
    }

    return target;
  }

  private clearscope
  string getTargetName(Actor target)
  {
    if (target.player) return target.player.getUserName();
    if (_settings.showInternalNames()) return target.getClassName();

    return addAdditionalInfo(target, target.getTag());
  }

  private clearscope
  string addAdditionalInfo(Actor target, string name)
  {
    Inventory inv = Inventory(target);
    if (inv)
    {
      int amount = inv.amount;
      if (amount == 1)
      {
        BasicArmorPickup armor = BasicArmorPickup(inv);
        if (armor) { amount = armor.saveAmount; }
      }
      if (amount == 1) return name;
      else             return string.format("%s (%i)", name, amount);
    }

    return prependChampionColor(target, name);
  }

  private clearscope
  string prependChampionColor(Actor target, string name)
  {
    if (!_settings.showChampion()) return name;

    string tokenClass = "champion_Token";
    Inventory   token = target.findInventory(tokenClass, true);
    if (!token) return name;

    string tokenClassName = token.getClassName();
    string championTag    = _data.championTokens.at(tokenClassName);
    if (championTag.length() == 0) { championTag = "Champion"; }

    championTag.appendFormat(" %s", name);
    return championTag;
  }

  private play
  bool isPreciseYAvailable() const
  {
    if (_preciseY != NULL) return true;

    _preciseY = Cvar.getCVar("pc_y", players[consolePlayer]);

    return (_preciseY != NULL);
  }

  private play
  double readY(Font aFont, double scale) const
  {
    int viewStartX, viewStartY, viewWidth, viewHeight;
    [viewStartX, viewStartY, viewWidth, viewHeight] = Screen.getViewWindow();

    double screenY = isPreciseYAvailable()
      ? (_preciseY.getFloat() - aFont.getHeight() / 2)
      : viewHeight / 2 + viewStartY;

    return screenY;
  }

  private clearscope
  string enableExtendedColorCode(string str)
  {
    str.replace('\c', string.format("%c", 28));
    return str;
  }

  private
  void initialize()
  {
    PlayerInfo player = players[consolePlayer];

    _glProjection  = new("ts_Le_GlScreen");
    _swProjection  = new("ts_Le_SwScreen");
    _cvarRenderer  = Cvar.getCvar("vid_rendermode", player);

    // for LZDoom
    if (_cvarRenderer == NULL)
    {
      _cvarRenderer = Cvar.getCvar("vid_renderer", player);
    }

    _isInitialized = true;
  }

  private
  void prepareProjection()
  {
    // Projection type detection is not quite right here.
    // vid_rendermode contains more complex information.
    // If something breaks, look here.
    if(_cvarRenderer)
    {
      switch (_cvarRenderer.getInt())
      {
      default:
        _projection = _glProjection;
        break;

      case 0:
      case 1:
        _projection = _swProjection;
        break;
      }
    }
    else
    {
      console.printf("warning, cannot get render mode");
      _projection = _glProjection;
    }

    _isPrepared = (_projection != NULL);
  }

  private
  void initService()
  {
    let i = ServiceIterator.find("TargetSpyService");
    Service aService;
    while (aService = i.next())
    {
      _extraInformationServices.push(aService);
    }
  }

  enum Background
  {
    BackgroundDisabled,
    BackgroundEnabled
  }

  private ts_Settings       _settings;
  private ts_Api            _api;

  private ts_LastTargetInfo _lastTargetInfo;

  private ts_Data _data;

  private ts_PlayToUiTranslator _translator;

  private transient Cvar _preciseY;

  private transient bool   _isInitialized;
  private transient bool   _isPrepared;
  private transient CVar   _cvarRenderer;

  private ts_Le_ProjScreen _projection;
  private ts_Le_GlScreen   _glProjection;
  private ts_Le_SwScreen   _swProjection;

  private Array<Service> _extraInformationServices;

  private ts_View _view;

} // class ts_EventHandler
