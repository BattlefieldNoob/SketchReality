/**
* MIT License
*  
* Copyright (c) 2019 Muhammad Iqbal
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
**/

/// default regex
const String placeholderPattern = '(\{\{([a-zA-Z0-9]+)\}\})';

/**
 * Replace string pattern consecutively.
 * Patterns are marked with double-curly brackets.
 * 
 * Example:
 * 
 *     var template = "My name is {{name}} and I'm {{age}} years old"
 *     sprintf(template, ['Oval', 17]);
 * 
 * Result:
 * 
 *     "My name is Oval and I'm 17 years old"
 * 
 **/
String sprintf(String template, List replacements) {
  var regExp = RegExp(placeholderPattern);
  assert(regExp.allMatches(template).length == replacements.length,
      "Template and Replacements length are incompatible");

  for (var replacement in replacements) {
    template = template.replaceFirst(regExp, replacement.toString());
  }

  return template;
}