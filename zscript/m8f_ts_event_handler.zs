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

class m8f_ts_EventHandler : EventHandler
{

  // EventHandler overrides section ////////////////////////////////////////////

  override
  void OnRegister()
  {
    multiSettings       = new("m8f_ts_MultiSettings").init();
    multiLastTargetInfo = new("m8f_ts_MultiLastTargetInfo").init();
    translator          = new("m8f_ts_PlayToUiTranslator");
  }

  override
  void WorldLoaded(WorldEvent e)
  {
    data               = new("m8f_ts_Data").init();
    isTitlemap         = m8f_ts_Game.CheckTitlemap();
    dehackedGameType   = m8f_ts_Game.GetDehackedGameType();

    cache              = new("m8f_ts_TagCache").init();
  }

  override
  void WorldThingDied(WorldEvent event)
  {
    if (event == NULL) { return; }

    Actor died = event.thing;
    if (died == NULL) { return; }

    for (int i = 0; i < MAXPLAYERS; ++i)
    {
      let lastTargetInfo = multiLastTargetInfo.get(i);
      if (lastTargetInfo.a == died)
      {
        lastTargetInfo.killTime = level.time;
      }
    }
  }

  override
  void WorldThingDamaged(WorldEvent event)
  {
    if (event == NULL) { return; }

    Actor damagedThing = event.thing;
    if (damagedThing == NULL) { return; }


    for (int i = 0; i < MAXPLAYERS; ++i)
    {
      let lastTargetInfo = multiLastTargetInfo.get(i);
      if (lastTargetInfo.a == damagedThing)
      {
        lastTargetInfo.hurtTime = level.time;
      }
    }
  }

  override
  void RenderOverlay(RenderEvent event)
  {
    if (isTitlemap) { return; }

    int        playerNumber = event.camera.PlayerNumber();
    PlayerInfo player       = players[playerNumber];
    Actor      playerActor  = player.mo;
    if (!playerActor) { return; }

    if (automapActive) { return; }

    drawEverything(playerNumber, event);
  }

  // Helper functions section //////////////////////////////////////////////////

  private ui
  void drawEverything(int playerNumber, RenderEvent event)
  {
    PlayerInfo player = players[playerNumber];
    if (!CVar.GetCVar("m8f_ts_enabled", player).GetInt()) { return; }

    Actor target = GetTarget(playerNumber, 0);

    draw(target, playerNumber, event);

    bool hasTarget = (target != NULL);
    CVar.GetCVar("m8f_ts_has_target", player).SetInt(hasTarget);
    Cvar.GetCVar("m8f_ts_friendly_target", player).SetInt(hasTarget && target.bFRIENDLY);

    if (hasTarget)
    {
      SetLastTarget(target, playerNumber);
    }
  }

  // https://forum.zdoom.org/viewtopic.php?f=122&t=61330#p1064117
  private ui
  void drawFrame(RenderEvent event, int playerNumber, Actor target, int color)
  {
    PlayerInfo player = players[playerNumber];

    let     worldToClip      = m8f_ts_Matrix.worldToClip( event.viewPos
                                                        , event.viewAngle
                                                        , event.viewPitch
                                                        , event.viewRoll
                                                        , player.FOV
                                                        );
    Vector3 adjustedWorldPos = event.viewPos + LevelLocals.vec3Diff(event.viewPos, target.pos);
    Vector3 ndcPos           = worldToClip.multiplyVector3(adjustedWorldPos + (0, 0, target.height / 2.0))
                                          .asVector3();

    if (-1 < ndcPos.z && ndcPos.z <= 1)
    {
      // this is the coordinates where you're drawing to:
      Vector2 centerPos     = m8f_ts_GlobalMaths.ndcToViewPort(ndcPos);
      double  distance      = player.mo.Distance3D(target);
      if (distance == 0) { return; }

      double  height        = target.height;
      double  radius        = target.radius;
      double  visibleRadius = radius * 2000.0 / distance;
      double  visibleHeight = height * 1000.0 / distance;

      let  settings         = multiSettings.get(playerNumber);
      let  f                = Font.GetFont(settings.fontName());

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
      double  scale       = 0.5 / settings.frameScale();

      switch (settings.frameStyle())
      {
        case settings.FRAME_DISABLED:
          break;

        case settings.FRAME_SLASH:
          drawCleanText(topLeft,     "/", f, color, scale);
          drawCleanText(bottomRight, "/", f, color, scale);
          break;

        case settings.FRAME_DOTS:
          drawCleanText(topLeft,     ".", f, color, scale);
          drawCleanText(topRight,    ".", f, color, scale);
          drawCleanText(bottomLeft,  ".", f, color, scale);
          drawCleanText(bottomRight, ".", f, color, scale);
          break;

        case settings.FRAME_LESS_GREATER:
          drawCleanText(left,  "<", f, color, scale);
          drawCleanText(right, ">", f, color, scale);
          break;

        case settings.FRAME_GREATER_LESS:
          drawCleanText(left,  ">", f, color, scale);
          drawCleanText(right, "<", f, color, scale);
          break;

        case settings.FRAME_BARS:
          drawCleanText(top,    ".", f, color, scale);
          drawCleanText(left,   "I", f, color, scale);
          drawCleanText(right,  "I", f, color, scale);
          drawCleanText(bottom, ".", f, color, scale);
          break;

        case settings.FRAME_GRAPHIC:
          {
            TextureID topLeftTex     = TexMan.CheckForTexture("ts_frame"              , TexMan.TryAny);
            TextureID topRightTex    = TexMan.CheckForTexture("ts_frame_top_right"    , TexMan.TryAny);
            TextureID bottomLeftTex  = TexMan.CheckForTexture("ts_frame_bottom_left"  , TexMan.TryAny);
            TextureID bottomRightTex = TexMan.CheckForTexture("ts_frame_bottom_right" , TexMan.TryAny);
            bool      animate        = false;
            Screen.SetClipRect( int(topLeft.x)
                              , int(topLeft.y)
                              , int(m8f_ts_Math.round(bottomRight.x - topLeft.x + 1))
                              , int(m8f_ts_Math.round(bottomRight.y - topLeft.y + 1))
                              );
            Screen.DrawTexture(topLeftTex,     animate, topLeft.x,     topLeft.y    );
            Screen.DrawTexture(topRightTex,    animate, topRight.x,    topRight.y   );
            Screen.DrawTexture(bottomLeftTex,  animate, bottomLeft.x,  bottomLeft.y );
            Screen.DrawTexture(bottomRightTex, animate, bottomRight.x, bottomRight.y);
            Screen.ClearClipRect();
          }
          break;
      }
    }
  }

  private static ui
  void drawCleanText(Vector2 pos, string str, Font f, int color, double scale)
  {
    int width  = int(scale * Screen.GetWidth());
    int height = int(scale * (Screen.GetHeight() - f.GetHeight()));

    Screen.drawText( f
                   , color
                   , (pos.x - (f.stringWidth(str) * cleanXFac / 2.0)) * scale
                   , (pos.y - (f.getHeight()      * cleanYFac / 2.0)) * scale
                   , str
                   , DTA_CleanNoMove   , true
                   , DTA_KeepRatio     , true
                   , DTA_VirtualWidth  , width
                   , DTA_VirtualHeight , height
                   );
  }

  // Wrapper to access lastTarget in scope play from ui scope.
  // not really const, but lastTarget doesn't affect gameplay.
  private ui
  void SetLastTarget(Actor newLastTarget, int playerNumber)
  {
    let lastTarget  = multiLastTargetInfo.get(playerNumber);
    lastTarget.a    = newLastTarget;
    lastTarget.name = GetTargetName(newLastTarget, dehackedGameType, playerNumber);
  }

  private play
  bool isSlot1Weapon(int playerNumber) const
  {
    PlayerInfo player = players[playerNumber];
    Weapon w = player.readyWeapon;
    if (w == NULL) { return true; }

    int located;
    int slot;
    int priority;
    [located, slot, priority] = player.weapons.LocateWeapon(w.GetClassName());
    return (slot == 1);
  }

  private ui
  void drawCrosshairs( Actor target
                     , int   crosshairColor
                     , Font  font
                     , int   playerNumber
                     )
  {
    let settings = multiSettings.get(playerNumber);

    if (!settings.crossOn()) { return; }

    if (settings.noCrossOnSlot1()
        && isSlot1Weapon(playerNumber))
    {
      return;
    }

    if (settings.hitConfirmation())
    {
      let lastTargetInfo = multiLastTargetInfo.get(playerNumber);
      if (lastTargetInfo.hurtTime != -1
          && (level.time < lastTargetInfo.hurtTime + 10))
      {
        crosshairColor = settings.hitColor();
      }
    }

    PlayerInfo player = players[playerNumber];

    double scale           = 0.5 / settings.crossScale();
    int    x, y, width, height;
    [x, y, width, height]  = Screen.GetViewWindow();
    int    screenHeight    = Screen.GetHeight();
    int    statusBarHeight = screenHeight - height - x;
    double relativeStatusBarHeight = double(statusBarHeight) * scale / screenHeight;
    double baseCenterY     = readY(player, font) - relativeStatusBarHeight;
    double topBottomShift  = 0.02;

    double topY            = baseCenterY - topBottomShift + settings.topOff();
    double topX            = 0.5;
    double centerY         = baseCenterY                  + settings.crossOff();
    double bottomY         = baseCenterY + topBottomShift + settings.botOff();
    double dx              = settings.xAdjustment();
    double opacity         = settings.crossOpacity();

    drawTextCenter(settings.crossTop(),  crosshairColor, scale, topX, topY   , font, dx, opacity);
    drawTextCenter(settings.crosshair(), crosshairColor, scale, topX, centerY, font, dx, opacity);
    drawTextCenter(settings.crossBot(),  crosshairColor, scale, topX, bottomY, font, dx, opacity);
  }

  private ui
  Vector2 getDefaultRelativeXY(m8f_ts_Settings settings)
  {
    Vector2 result;
    result.x = 0.5;
    result.y = settings.yStart() + settings.yOffset();
    return result;
  }

  private ui
  vector2 getRelativeXY( Actor           target
                       , PlayerInfo      player
                       , RenderEvent     event
                       , m8f_ts_Settings settings
                       )
  {
    if (target == NULL) { return getDefaultRelativeXY(settings); }

    if (settings.barsOnTarget())
    {
      let worldToClip = m8f_ts_Matrix.worldToClip( event.viewPos
                                                 , event.viewAngle
                                                 , event.viewPitch
                                                 , event.viewRoll
                                                 , player.FOV
                                                 );
      double y = (settings.barsOnTarget() == m8f_ts_Settings.ON_TARGET_ABOVE)
               ? target.height * 1.2
               : -5;
      Vector3 adjustedWorldPos = event.viewPos + LevelLocals.vec3Diff(event.viewPos, target.pos);
      Vector3 ndcPos           = worldToClip.multiplyVector3(adjustedWorldPos + (0, 0, y)).asVector3();

      if (-1 < ndcPos.z && ndcPos.z <= 1)
      {
        // this is the coordinates where you're drawing to:
        Vector2 centerPos = m8f_ts_GlobalMaths.ndcToViewPort(ndcPos);
        Vector2 result;
        result.x = centerPos.x / Screen.GetWidth();
        result.y = clamp(centerPos.y / Screen.GetHeight(), 0.1, 0.9);
        return result;
      }
    }

    return getDefaultRelativeXY(settings);
  }

  private ui
  void draw(Actor target, int playerNumber, RenderEvent event)
  {
    let        settings = multiSettings.get(playerNumber);
    PlayerInfo player   = players[playerNumber];

    vector2 xy = getRelativeXY(target, player, event, settings);
    double  x  = xy.x;
    double  y  = xy.y;

    double newline = 0.03 * settings.stepMult();
    if ((y >= 0.80 && settings.barsOnTarget() != m8f_ts_Settings.ON_TARGET_BELOW)
        || settings.barsOnTarget() == m8f_ts_Settings.ON_TARGET_ABOVE) { newline = -newline; }

    Font font      = Font.GetFont(settings.fontName());
    Font crossfont = Font.GetFont(settings.crossFontName());

    if (settings.barsOnTarget() == m8f_ts_Settings.ON_TARGET_DISABLED)
    {
      y = drawKillConfirmed(x, y, newline, font, playerNumber);
    }
    else
    {
      vector2 defaultXy = getDefaultRelativeXY(settings);
      drawKillConfirmed(defaultXy.x, defaultXy.y, newline, font, playerNumber);
    }

    bool hasTarget = (target != NULL);
    int  crossCol  = settings.crossCol();

    if (!hasTarget)
    {
      drawCrosshairs(target, crossCol, crossFont, playerNumber);
      return;
    }

    int    targetMaxHealth = m8f_ts_ActorInfo.GetActorMaxHealth(target);
    bool   showHealth      = (targetMaxHealth != 0);
    string legendaryToken  = "LDLegendaryMonsterToken";

    if (target.CountInv(legendaryToken) > 0)
    {
      targetMaxHealth *= 3;
    }

    if (targetMaxHealth < settings.minHealth() && targetMaxHealth != 0)
    {
      drawCrosshairs(target, crossCol, crossFont, playerNumber);
      return; // not worth showing
    }

    int targetHealth = target.health;
    if (targetHealth < 1 && !settings.showCorps()) // target is dead
    {
      drawCrosshairs(target, crossCol, crossFont, playerNumber);
      return;
    }

    int tagColor;
    if (targetMaxHealth < 100) { tagColor = settings.weakCol(); }
    else                       { tagColor = settings.nameCol(); }
    int customColor = m8f_ts_ActorInfo.CustomTargetColor(target);
    if (customColor)           { tagColor = customColor; }

    int percent = 10;
    if (showHealth)
    {
      if (targetHealth > targetMaxHealth) { percent = 11; }
      else { percent = targetHealth * 10 / targetMaxHealth; }
    }

    if (percent < 0) { percent = 0; }
    int targetColor = settings.colors(percent);
    if (targetHealth < 35 && settings.almDeadCr()) targetColor = settings.crAlmDead();
    if (targetHealth < 1)                        targetColor = settings.crAlmDead();

    drawCrosshairs(target, targetColor, crossFont, playerNumber);

    double textScale = 0.5 / settings.textScale();
    double opacity   = settings.opacity();

    if (settings.showBar() && showHealth)
    {
      string hpBar = m8f_ts_String.MakeHpBar( targetHealth
                                            , targetMaxHealth
                                            , settings.logScale()
                                            , settings.altHpCols()
                                            , settings.greenCr()
                                            , settings.redCr()
                                            , settings.lengthMultiplier()
                                            , settings.pip()
                                            , settings.emptyPip()
                                            );
      drawTextCenter(hpBar, targetColor, textScale, x, y, font, 0.0, opacity);
      y += newline;
    }

    int nameColor = tagColor;
    if (targetHealth < 1) { nameColor = targetColor; }

    if (settings.showName())
    {
      string targetName = GetTargetName(target, dehackedGameType, playerNumber);
      targetName.replace('\c', String.Format("%c", 28));

      if (targetHealth < 1)
      {
        targetName = String.Format("Remains of %s", targetName);
        nameColor  = targetColor;
      }

      drawTextCenter(targetName, nameColor, textScale, x, y, font, 0.0, opacity);
      y += newline;
    }

    if (settings.showInfo())
    {
      string targetFlags = m8f_ts_ActorInfo.GetTargetFlags(target);
      if (targetFlags.Length() > 0)
      {
        drawTextCenter(targetFlags, nameColor, textScale, x, y, font, 0.0, opacity);
        y += newline;
      }
    }

    if (showHealth)
    {
      switch (settings.showNums())
      {
        case 0: break;

        case 1:
          drawTextCenter( String.Format("%d/%d", targetHealth, targetMaxHealth)
                        , targetColor
                        , textScale
                        , x
                        , y
                        , font
                        , 0.0
                        , opacity
                        );
          y += newline;
          break;

        case 2:
          drawTextCenter( String.Format("%d", targetHealth)
                        , targetColor
                        , textScale
                        , x
                        , y
                        , font
                        , 0.0
                        , opacity
                        );
          y += newline;
          break;

        case 3:
          int percent100;
          if (targetMaxHealth == 0) { percent100 = 100; }
          else { percent100 = m8f_ts_Math.round(targetHealth * 100.0 / targetMaxHealth); }

          drawTextCenter( String.Format("%d%%", percent100)
                        , targetColor
                        , textScale
                        , x
                        , y
                        , font
                        , 0.0
                        , opacity
                        );
          y += newline;
          break;

        case 4:
          double percent100dot00;
          if (targetMaxHealth == 0) { percent100dot00 = 100; }
          else { percent100dot00 = targetHealth * 100.0 / targetMaxHealth; }

          drawTextCenter( String.Format("%.2f%%", percent100dot00)
                        , targetColor
                        , textScale
                        , x
                        , y
                        , font
                        , 0.0
                        , opacity
                        );
          y += newline;
          break;
      }
    }

    if (settings.frameStyle() != settings.FRAME_DISABLED)
    {
      drawFrame(event, playerNumber, target, targetColor);
    }
  }

  private ui
  double drawKillConfirmed( double x
                          , double y
                          , double newline
                          , Font   font
                          , int    playerNumber
                          )
  {
    let settings = multiSettings.get(playerNumber);

    if (!settings.showKillConfirmation()) { return y; }

    let lastTargetInfo = multiLastTargetInfo.get(playerNumber);

    if (lastTargetInfo.killTime == -1) { return y; }

    if (level.time < lastTargetInfo.killTime + 35 * 1)
    {
      double scale     = 0.5 / settings.textScale();
      double opacity   = settings.opacity();
      int    nameColor = settings.nameCol();
      string text = (settings.namedConfirmation())
        ? lastTargetInfo.name .. " killed"
        : "Kill Confirmed";

      lastTargetInfo.name.replace('\c', String.Format("%c", 28));
      drawTextCenter(text, nameColor, scale, x, y, font, 0.0, opacity);
      y += newline;
    }

    return y;
  }

  private ui
  void drawTextCenter( string text
                     , int    color
                     , double scale
                     , double relativeX
                     , double relativeY
                     , Font   font
                     , double xAdjustment
                     , double opacity
                     )
  {
    int width    = int(scale * Screen.GetWidth());
    int height   = int(scale * (Screen.GetHeight() - font.GetHeight()));
    int position = width - font.StringWidth(text);

    double x = position * relativeX + xAdjustment;
    double y = height   * relativeY;

    Screen.DrawText( font
                   , color
                   , x
                   , y
                   , text
                   , DTA_KeepRatio     , true
                   , DTA_VirtualWidth  , width
                   , DTA_VirtualHeight , height
                   , DTA_Alpha         , opacity
                   );
  }

  private ui
  Actor GetTarget(int playerNumber, int gameType)
  {
    PlayerInfo player = players[playerNumber];
    if (!player) { return NULL; }
    Actor playerActor = player.mo;
    if (!playerActor) { return NULL; }

    // try an easy way to get a target (also works with autoaim)
    Actor target   = translator.AimTargetWrapper(player.mo);
    let   settings = multiSettings.get(playerNumber);

    // if target is not found by easy way, try the difficult way
    if (target == NULL)
    {
      target = translator.LineAttackTargetWrapper(player.mo, player.viewheight);
    }

    if (target == NULL && settings.showObjects() > 1)
    {
      target = translator.AimLineAttackWrapper(player.mo);
    }

    // give up
    if (target == NULL) { return NULL; }

    // target is found

    // check sector lighting
    if (settings.hideInDarkness())
    {
      bool noLightAmplifier = (playerActor.FindInventory("PowerLightAmp") == NULL)
        && (playerActor.FindInventory("PowerInvulnerable") == NULL);
      if (noLightAmplifier)
      {
        Sector targetSector = target.curSector;
        int    lightlevel   = targetSector.lightlevel;
        if (lightLevel < settings.minimalLightLevel()) { return NULL; }
      }
    }

    string targetClass   = target.GetClassName();
    bool   targetIsSlave = data.slaveActors.contains(targetClass);
    if (targetIsSlave)
    {
      target      = target.Master;
      targetClass = target.GetClassName();
    }

    bool isInBlackList = data.blackList.contains(targetClass);
    if (isInBlackList) { return NULL; }

    switch (gameType)
    {
      case 1: targetClass.AppendFormat("_free" ); break; // Freedoom
      case 2: targetClass.AppendFormat("_rekkr"); break; // Rekkr
    }

    // everything without name in REKKR is "blacklisted"
    if (targetClass.IndexOf("_rekkr") != -1)
    {
      string specialName = data.specialNames.get(targetClass);
      if (specialName.length() == 0) { return NULL; }
    }

    if (target.bISMONSTER)
    {
      bool targetIsHidden = (target.bSHADOW || target.bSTEALTH);
      if (!settings.showHidden()  && targetIsHidden)   { return NULL; }
      if (!settings.showFriends() && target.bFRIENDLY) { return NULL; }
      if (!settings.showDormant() && target.bDORMANT)  { return NULL; }
      if (!settings.showIdle()    && m8f_ts_ActorInfo.IsIdle(target)) { return NULL; }
    }
    else // not monsters
    {
      if (target.player) { return target; }

      switch (settings.showObjects())
      {
        case 0: return NULL;
        case 1:
          if (target.bSHOOTABLE) { return target; }
          else                   { return NULL;   }
        case 2:
          if (target.bSHOOTABLE || target is "Inventory") { return target; }
          else                                            { return NULL;   }
        case 3:
          return target;
      }
    }

    return target;
  }

  private ui
  string GetTargetName(Actor target, int gameType, int playerNumber)
  {
    if (target.player) { return target.player.GetUserName(); }

    string targetClass = target.GetClassName();

    switch (multiSettings.get(playerNumber).showInternalNames())
    {
      case 0: break;
      case 1: return targetClass;
      case 2: return m8f_ts_String.Beautify(targetClass);
    }

    switch (gameType)
    {
      case 1: targetClass.AppendFormat("_free" ); break; // Freedoom
      case 2: targetClass.AppendFormat("_rekkr"); break; // Rekkr
    }

    // if target name was found before, just return it
    if (cache.cachedClass == targetClass)
    {
      return AddAdditionalInfo(target, cache.cachedTag, playerNumber);
    }

    // if target name is set via actor tag, return it
    string targetName = target.GetTag();
    if (targetName != targetClass && !(gameType != 0))
    {
      cache.SetCache(targetClass, targetName);
      return AddAdditionalInfo(target, targetName, playerNumber);
    }

    string specialName = data.specialNames.get(targetClass);
    if (specialName.Length() != 0)
    {
      targetName = specialName;
      cache.SetCache(targetClass, targetName);
      return AddAdditionalInfo(target, targetName, playerNumber);
    }

    // if target name is not found, compose tag from class name
    targetName = m8f_ts_String.Beautify(targetName);

    cache.SetCache(targetClass, targetName);
    return AddAdditionalInfo(target, targetName, playerNumber);
  }

  private ui
  string AddAdditionalInfo(Actor target, string name, int playerNumber)
  {
    Inventory inv = Inventory(target);
    if (inv)
    {
      int amount = inv.amount;
      if (amount == 1)
      {
        BasicArmorPickup armor = BasicArmorPickup(inv);
        if (armor) { amount = armor.SaveAmount; }
      }
      if (amount == 1) { return name; }
      else             { return String.Format("%s (%i)", name, amount); }
    }
    else
    {
      return PrependChampionColor(target, name, playerNumber);
    }
  }

  private ui
  string PrependChampionColor(Actor target, string name, int playerNumber)
  {
    if (!multiSettings.get(playerNumber).showChampion()) { return name; }

    string tokenClass = "champion_Token";
    Inventory token = target.FindInventory(tokenClass, true);
    if (!token) { return name; }

    string tokenClassName = token.GetClassName();
    string championTag    = data.championTokens.get(tokenClassName);
    if (championTag.Length() == 0) { championTag = "Champion"; }

    championTag.AppendFormat(" %s", name);
    return championTag;
  }

  private play
  bool isPreciseYAvailable(PlayerInfo player) const
  {
    if (_preciseY != NULL) { return true; }

    _preciseY = Cvar.GetCVar("pc_y", player);

    return (_preciseY != NULL);
  }

  private play
  double readY(PlayerInfo player, Font f) const
  {
    return isPreciseYAvailable(player)
      ? (_preciseY.GetFloat() - f.GetHeight() / 2) / Screen.GetHeight()
      : 0.51
      ;
  }

  // private: //////////////////////////////////////////////////////////////////

  private m8f_ts_MultiSettings       multiSettings;
  private m8f_ts_MultiLastTargetInfo multiLastTargetInfo;

  private m8f_ts_Data     data;
  private bool            isTitlemap;
  private int             dehackedGameType;

  private m8f_ts_TagCache cache;
  private m8f_ts_PlayToUiTranslator translator;

  private transient Cvar _preciseY;

} // class m8f_ts_EventHandler
