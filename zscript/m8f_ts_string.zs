/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2018
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

class m8f_ts_String
{

  ui static string Beautify(string s)
  {
    string result = SeparateCamelCase(s);
    result.Replace("_", " ");
    return result;
  }

  ui static string SeparateCamelCase(string source)
  {
    int sourceLength = source.Length();
    string result = "";
    string letter1 = source.CharAt(0);
    string letter2;

    for (int i = 1; i < sourceLength; ++i)
      {
        letter2 = source.CharAt(i);
        if (IsSmallLetter(letter1) && IsBigLetter(letter2))
          {
            result.AppendFormat("%s ", letter1);
          }
        else
          {
            result.AppendFormat(letter1);
          }
        letter1 = letter2;
      }
    result.AppendFormat(letter2);

    return result;
  }

  ui static bool IsSmallLetter(string letter)
  {
    int code = letter.CharCodeAt(0);
    return (97 <= code && code <= 122);
  }

  ui static bool IsBigLetter(string letter)
  {
    int code = letter.CharCodeAt(0);
    return (65 <= code && code <= 90);
  }

  ui static
  string MakeHpBar( int    health
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

    length = m8f_ts_Math.round(length * lengthMultiplier);

    int nPips;
    if (maxHealth < 1)
    {
      nPips = 1;
    }
    else
    {
      nPips = health * length / maxHealth;
      nPips = clamp(nPips, 1, length);
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

  static string MakeRepeating(string s, int n)
  {
    string format = String.Format("%%%ds", n);
    string result = String.Format(format, " ");
    result.replace(" ", s);
    return result;
  }

} // class m8f_ts_String
