unit Test.Tokeniser.Tokens;

interface

//////////////////////////////////////////////////////////////////////////////////
// The positions of the strings are for NON-ARC compilers (eg.Win32, Win64, etc.)
//////////////////////////////////////////////////////////////////////////////////

const
  tokenTestName1 = 'Identifier';
  tokenTestPass1 = '[123]';
  tokenTestExpected1 =
              '{Token: LSquareBracket; Value: [; (1,0) --> (1,0)}'+sLineBreak+
              '{Token: Identifier; Value: 123; (2,0) --> (4,0)}'+sLineBreak+
              '{Token: RSquareBracket; Value: ]; (5,0) --> (5,0)}';
  tokenTestNumTokens1 = '3';
  tokenTest1 = tokenTestPass1+'#'+tokenTestExpected1+'#'+tokenTestNumTokens1;
///////////////////////////////////////////////////////////
  tokenTestName2 = 'Identifier with Spaces';
  tokenTestPass2 = '[1 23 ]';
  tokenTestExpected2 =
            '{Token: LSquareBracket; Value: [; (1,0) --> (1,0)}'+sLineBreak+
            '{Token: Identifier; Value: 123; (2,0) --> (5,0)}'+sLineBreak+
            '{Token: RSquareBracket; Value: ]; (7,0) --> (7,0)}';
  tokenTestNumTokens2 = '3';
  tokenTest2 = tokenTestPass2+'#'+tokenTestExpected2+'#'+tokenTestNumTokens2;
///////////////////////////////////////////////////////////
  tokenTestName3 = 'Identifier with Spaces At the beginning';
  tokenTestPass3= '  [1]';
  tokenTestExpected3=
          '{Token: LSquareBracket; Value: [; (3,0) --> (3,0)}'+sLineBreak+
          '{Token: Identifier; Value: 1; (4,0) --> (4,0)}'+sLineBreak+
          '{Token: RSquareBracket; Value: ]; (5,0) --> (5,0)}';
  tokenTestNumToken3 = '3';
  tokenTest3 = tokenTestPass3+'#'+tokenTestExpected3+'#'+tokenTestNumToken3;
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
  tokenTest4 = tokenTestPass4+'#'+tokenTestExpected4+'#'+tokenTestNumToken4;
///////////////////////////////////////////////////////////
  tokenTestName5 = 'Identifier without []';
  tokenTestPass5 = 'plainIdentifier';
  tokenTestExpected5 =
            '{Token: Identifier; Value: plainIdentifier; (1,1) --> (15,0)}';
  tokenTestNumTokens5 = '1';
  tokenTest5 = tokenTestPass5+'#'+tokenTestExpected5+'#'+tokenTestNumTokens5;
implementation

end.
