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
    FLineTraceData lineTraceData;
    a.LineTrace(a.angle, 4000.0, a.pitch, 0, offsetz, 0.0, 0.0, lineTraceData);
    if (lineTraceData.HitType != TRACE_HitActor)
    {
      ThinkerIterator noBlockmapActors = ThinkerIterator.Create();
      Actor nbmActor;
      Actor closestNbmActor;
      while (nbmActor = Actor(noBlockmapActors.Next()))
      {
        if (nbmActor.bNoBlockmap == false) { continue; } else
        {
          vector3 nbmActorCenter = (nbmActor.pos.x, nbmActor.pos.y, nbmActor.pos.z + nbmActor.height/2);
          double nbmActorRadius = max(nbmActor.height,nbmActor.radius * 2)/2;
          vector3 LineStart = (a.pos.x,a.pos.y,a.pos.z+offsetz);
          vector3 LineEnd = lineTraceData.HitLocation;
          vector3 Direction = (LineEnd - LineStart).Unit();
          // a * x^2 + b*x + c = 0
          double a = Direction dot Direction;
          double b = 2 * Direction dot (LineStart - nbmActorCenter);
          double c = (LineStart - nbmActorCenter) dot (LineStart - nbmActorCenter) - nbmActorRadius * nbmActorRadius;
          // x = ( -b ± (b * b - 4 * a * c)^(1/2) ) / 2 * a
          double discriminant = b * b - 4 * a * c;
          if (discriminant >= 0)
          {
            if ((LineStart - LineEnd).Length() >= (LineStart - nbmActor.pos).Length())
            {
              if (closestNbmActor == NULL) { closestNbmActor = nbmActor; } else
              {
                if ((LineStart - nbmActor.pos).Length() < (LineStart - closestNbmActor.pos).Length())
                {
                    closestNbmActor = nbmActor;
                }
              }
            }
          }
        }
      }
      return closestNbmActor;
    }
    return NULL;
  }

} // class m8f_ts_PlayToUiTranslator
