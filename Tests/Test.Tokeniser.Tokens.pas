unit Test.Tokeniser.Tokens;

interface

//////////////////////////////////////////////////////////////////////////////////
// The positions of the strings are for NON-ARC compilers (eg.Win32, Win64, etc.)
//////////////////////////////////////////////////////////////////////////////////

const
  testSeparator = '£';

  tokenTestName1 = 'Identifier';
  tokenTestPass1 = '[123]';
  tokenTestExpected1 =
              '{Token: LSquareBracket; Value: [; (1,0) --> (1,0)}'+sLineBreak+
              '{Token: Identifier; Value: 123; (2,0) --> (4,0)}'+sLineBreak+
              '{Token: RSquareBracket; Value: ]; (5,0) --> (5,0)}';
  tokenTestNumTokens1 = '3';
  tokenTest1 = tokenTestPass1+testSeparator+tokenTestExpected1+testSeparator+
                                                            tokenTestNumTokens1;
///////////////////////////////////////////////////////////
  tokenTestName2 = 'Identifier with Spaces';
  tokenTestPass2 = '[1 23 ]';
  tokenTestExpected2 =
            '{Token: LSquareBracket; Value: [; (1,0) --> (1,0)}'+sLineBreak+
            '{Token: Identifier; Value: 1; (2,0) --> (2,0)}'+sLineBreak+
            '{Token: Space; Value: (space); (3,0) --> (3,0)}'+sLineBreak+
            '{Token: Identifier; Value: 23; (4,0) --> (5,0)}'+sLineBreak+
            '{Token: Space; Value: (space); (6,0) --> (6,0)}'+sLineBreak+
            '{Token: RSquareBracket; Value: ]; (7,0) --> (7,0)}';
  tokenTestNumTokens2 = '6';
  tokenTest2 = tokenTestPass2+testSeparator+tokenTestExpected2+testSeparator+
                                                            tokenTestNumTokens2;
///////////////////////////////////////////////////////////
  tokenTestName3 = 'Identifier with Spaces At the beginning';
  tokenTestPass3= '  [1]';
  tokenTestExpected3=
          '{Token: Space; Value: (space); (1,0) --> (1,0)}'+sLineBreak+
          '{Token: Space; Value: (space); (2,0) --> (2,0)}'+sLineBreak+
          '{Token: LSquareBracket; Value: [; (3,0) --> (3,0)}'+sLineBreak+
          '{Token: Identifier; Value: 1; (4,0) --> (4,0)}'+sLineBreak+
          '{Token: RSquareBracket; Value: ]; (5,0) --> (5,0)}';
  tokenTestNumToken3 = '5';
  tokenTest3 = tokenTestPass3+testSeparator+tokenTestExpected3+testSeparator
                                                            +tokenTestNumToken3;
///////////////////////////////////////////////////////////
  tokenTestName4 = 'Identifier with Underscore';
  tokenTestPass4= '[request_definition]';
  tokenTestExpected4=
        '{Token: LSquareBracket; Value: [; (1,0) --> (1,0)}'+sLineBreak+
        '{Token: Identifier; Value: request; (2,0) --> (8,0)}'+sLineBreak+
        '{Token: Underscore; Value: _; (9,0) --> (9,0)}'+sLineBreak+
        '{Token: Identifier; Value: definition; (10,0) --> (19,0)}'+sLineBreak+
        '{Token: RSquareBracket; Value: ]; (20,0) --> (20,0)}';
  tokenTestNumToken4 = '5';
  tokenTest4 = tokenTestPass4+testSeparator+tokenTestExpected4+testSeparator
                                                            +tokenTestNumToken4;
///////////////////////////////////////////////////////////
  tokenTestName5 = 'Identifier without []';
  tokenTestPass5 = 'plainIdentifier';
  tokenTestExpected5 =
            '{Token: Identifier; Value: plainIdentifier; (1,0) --> (15,0)}';
  tokenTestNumTokens5 = '1';
  tokenTest5 = tokenTestPass5+testSeparator+tokenTestExpected5+testSeparator
                                                          +tokenTestNumTokens5;
///////////////////////////////////////////////////////////
  tokenTestName6 = 'OneChar Tokens';
  // Here we test individual characters so we use #10#13 instead of
  // #13#10 because in Windows this is EOL
  tokenTestPass6 = '#;[]=,()_.+-*/%><'+#9+#32+#10+#13+' \';
  tokenTestExpected6 =
            '{Token: Comment; Value: #; (1,0) --> (1,0)}'+sLineBreak+
            '{Token: Comment; Value: ;; (2,0) --> (2,0)}'+sLineBreak+
            '{Token: LSquareBracket; Value: [; (3,0) --> (3,0)}'+sLineBreak+
            '{Token: RSquareBracket; Value: ]; (4,0) --> (4,0)}'+sLineBreak+
            '{Token: Equality; Value: =; (5,0) --> (5,0)}'+sLineBreak+
            '{Token: Comma; Value: ,; (6,0) --> (6,0)}'+sLineBreak+
            '{Token: LParenthesis; Value: (; (7,0) --> (7,0)}'+sLineBreak+
            '{Token: RParenthesis; Value: ); (8,0) --> (8,0)}'+sLineBreak+
            '{Token: Underscore; Value: _; (9,0) --> (9,0)}'+sLineBreak+
            '{Token: Dot; Value: .; (10,0) --> (10,0)}'+sLineBreak+
            '{Token: Add; Value: +; (11,0) --> (11,0)}'+sLineBreak+
            '{Token: Minus; Value: -; (12,0) --> (12,0)}'+sLineBreak+
            '{Token: Multiply; Value: *; (13,0) --> (13,0)}'+sLineBreak+
            '{Token: Divide; Value: /; (14,0) --> (14,0)}'+sLineBreak+
            '{Token: Modulo; Value: %; (15,0) --> (15,0)}'+sLineBreak+
            '{Token: GreaterThan; Value: >; (16,0) --> (16,0)}'+sLineBreak+
            '{Token: LowerThan; Value: <; (17,0) --> (17,0)}'+sLineBreak+
            '{Token: Tab; Value: (tab); (18,0) --> (18,0)}'+sLineBreak+
            '{Token: Space; Value: (space); (19,0) --> (19,0)}'+sLineBreak+
            '{Token: LF; Value: (lf); (20,0) --> (20,0)}'+sLineBreak+
            '{Token: CR; Value: (cr); (21,0) --> (21,0)}'+sLineBreak+
            '{Token: Space; Value: (space); (22,0) --> (22,0)}'+sLineBreak+
            '{Token: Backslash; Value: \; (23,0) --> (23,0)}';
  tokenTestNumTokens6= '23';
  tokenTest6 = tokenTestPass6+testSeparator+tokenTestExpected6+testSeparator
                                                          +tokenTestNumTokens6;
///////////////////////////////////////////////////////////
  tokenTestName7 = 'Identifier without [] and space';
  tokenTestPass7 = 'plain Identifier';
  tokenTestExpected7 =
            '{Token: Identifier; Value: plain; (1,0) --> (5,0)}'+sLineBreak+
            '{Token: Space; Value: (space); (6,0) --> (6,0)}'+sLineBreak+
            '{Token: Identifier; Value: Identifier; (7,0) --> (16,0)}';
  tokenTestNumTokens7 = '3';
  tokenTest7 = tokenTestPass7+testSeparator+tokenTestExpected7+testSeparator
                                                          +tokenTestNumTokens7;
///////////////////////////////////////////////////////////
  tokenTestName8 = 'Multiline identifier with space';
  tokenTestPass8 = '[two line '+slineBreak+'  identifier]';
  tokenTestExpected8 =
          '{Token: LSquareBracket; Value: [; (1,0) --> (1,0)}'+sLineBreak+
          '{Token: Identifier; Value: two; (2,0) --> (4,0)}'+sLineBreak+
          '{Token: Space; Value: (space); (5,0) --> (5,0)}'+sLineBreak+
          '{Token: Identifier; Value: line; (6,0) --> (9,0)}'+sLineBreak+
          '{Token: Space; Value: (space); (10,0) --> (10,0)}'+sLineBreak+
          '{Token: EOL; Value: (eol); (11,0) --> (11,0)}'+sLineBreak+
          '{Token: Space; Value: (space); (1,1) --> (1,1)}'+sLineBreak+
          '{Token: Space; Value: (space); (2,1) --> (2,1)}'+sLineBreak+
          '{Token: Identifier; Value: identifier; (3,1) --> (12,1)}'+sLineBreak+
          '{Token: RSquareBracket; Value: ]; (13,1) --> (13,1)}';
  tokenTestNumTokens8 = '10';
  tokenTest8 = tokenTestPass8+testSeparator+tokenTestExpected8+testSeparator
                                                          +tokenTestNumTokens8;
///////////////////////////////////////////////////////////
  tokenTestName9 = 'Identifier with Unicode';
  tokenTestPass9= '[νεοςновак新生]';
  tokenTestExpected9=
        '{Token: LSquareBracket; Value: [; (1,0) --> (1,0)}'+sLineBreak+
        '{Token: Identifier; Value: νεοςновак新生; (2,0) --> (12,0)}'+sLineBreak+
        '{Token: RSquareBracket; Value: ]; (13,0) --> (13,0)}';
  tokenTestNumToken9 = '3';
  tokenTest9 = tokenTestPass9+testSeparator+tokenTestExpected9+testSeparator
                                                            +tokenTestNumToken9;

implementation

end.
