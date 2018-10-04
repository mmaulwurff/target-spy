/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2018
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

class m8f_ts_LastTargetInfo
{

  Actor a;
  int   killTime;
  int   hurtTime;

  m8f_ts_LastTargetInfo init()
  {
    a        = null;
    killTime = -1;
    hurtTime = -1;

    return self;
  }

} // class m8f_ts_LastTargetInfo
