unit Casbin.Core.Defaults;

interface

uses
  System.SysUtils, System.Types;

const
  DefaultSection = 'default';
  DefaultCommentCharacters : TCharArray = ['#',';'];
  DefaultMultilineCharacters : string = '\\';
  EOL = sLineBreak;
  AssignmentCharForModel = '=';
  AssignmentCharForPolicies = ',';
  AssignmentCharForConfig = '=';

implementation

end.
