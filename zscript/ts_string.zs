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

class ts_String
{

  ui static
  string makeHpBar( int    health
                  , int    maxHealth
                  , bool   logScale
                  , bool   greenRedTheme
                  , int    greenColor
                  , int    redColor
                  , double lengthMultiplier
                  , string pip
                  , string emptyPip
                  )
  {
    int length;
    if      (logScale)          { length = int(Log(maxHealth)) * 2; }
    else if (maxHealth >= 2000) { length = 30; }
    else if (maxHealth >= 500)  { length = 20; }
    else                        { length = 10; }

    length = int(round(length * lengthMultiplier));

    int nPips;
    if (maxHealth < 1)
    {
      nPips = 0;
    }
    else
    {
      nPips = int(round(double(health) * length / maxHealth));
      nPips = clamp(nPips, 0, length);
    }

    string pipColor;
    string emptyColor;
    if (greenRedTheme)
    {
      pipColor   = String.Format("\c%c", 97 + greenColor); // 'a'
      emptyColor = String.Format("\c%c", 97 + redColor);   // 'a'
    }
    else
    {
      pipColor   = "";
      emptyColor = "";
    }

    return String.Format( "%s%s%s%s"
                        , pipColor
                        , MakeRepeating(pip, nPips)
                        , emptyColor
                        , MakeRepeating(emptyPip, length - nPips)
                        );

  }

  static
  string appendWithSpace(string head, string tail)
  {
    string result = head;
    if (result.Length() > 0) { result.appendFormat(" "); }
    result.appendFormat(tail);
    return result;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private static
  string makeRepeating(string s, int n)
  {
    if (n == 0) { return ""; }
    string format = string.format("%%%ds", n);
    string result = string.format(format, " ");
    result.replace(" ", s);
    return result;
  }

} // class ts_String
