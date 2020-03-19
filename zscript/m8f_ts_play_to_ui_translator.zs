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

/**
 * Hack. The purpose of this class is to access play functions from UI scope.
 */
class m8f_ts_PlayToUiTranslator
{

  play Actor AimTargetWrapper(Actor a) const
  {
    return a.AimTarget();
  }

  play Actor LineAttackTargetWrapper(Actor a, double offsetz) const
  {
    FLineTraceData lineTraceData;
    a.LineTrace(a.angle, 4000.0, a.pitch, 0, offsetz, 0.0, 0.0, lineTraceData);
    return lineTraceData.HitActor;
  }

  play Actor AimLineAttackWrapper(Actor a) const
  {
    FTranslatedLineTarget ftlt;
    a.AimLineAttack(a.angle, 2048.0, ftlt, 0,
                    ALF_CHECKNONSHOOTABLE | ALF_FORCENOSMART);
    return ftlt.linetarget;
  }

  play Actor LineAttackNoBlockmapWrapper(Actor a, double offsetz) const
  {
    return ts_NoblockmapDetection.LineAttackNoBlockmap(a, offsetz);
  }

} // class m8f_ts_PlayToUiTranslator
