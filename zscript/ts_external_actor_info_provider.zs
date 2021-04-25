/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2021
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
 * Inherit this class and implement getInfo() method to make Target Spy display
 * additional information about the target.
 *
 * No further setup required. Target Spy will instantiate and call this class
 * when needed.
 */
class ts_ExternalActorInfoProvider abstract
{
  /**
   * If empty string is returned, the output is ignored.
   */
  string getInfo(Actor anActor)
  {
    return "";
  }
}

// Example: this provider returns class tag repeated twice.
//
//class ts_ExternalActorInfoProviderDoubleName : ts_ExternalActorInfoProvider
//{
//  override
//  string getInfo(Actor anActor)
//  {
//    return anActor.getTag() .. "-" .. anActor.getTag();
//  }
//}
