unit Casbin.AST.Utilities;

interface

uses
  Casbin.Lexer.Tokens.List, Casbin.AST.Types;


procedure addAssertion(const tokenList: TTokenList; var attachTo: THeadNode);

implementation

uses
  System.SysUtils, Casbin.Lexer.Tokens.Types, System.StrUtils, Casbin.Model.Sections.Default, Casbin.Model.Sections.Types;

type
  TTokenBuf = record
    Previous: PToken;
    Current: PToken;
    Next: PToken;
  end;

procedure addAssertion(const tokenList: TTokenList; var attachTo: THeadNode);
var
  token: PToken;
  buffer: TTokenBuf;
  header: THeaderNode;
  i: Integer;
  isHeader: Boolean;
begin
  if not Assigned(tokenList) then
    raise Exception.Create('tokenList is nil');
  if not Assigned(attachTo) then
    raise Exception.Create('attachTo is nil');

  //attachTo always points to HeadNode

  //HEADER
  isHeader:=False;
  for token in tokenList do
  begin
    if token^.&Type = ttLSquareBracket then
    begin
      isHeader:=True;
      Exit;
    end;
  end;

  if isHeader and (tokenList.Count>=3) and
        (tokenList.Items[0]^.&Type=ttLSquareBracket) and
          (tokenList.Items[1]^.&Type=ttIdentifier) and
            (tokenList.Items[1]^.&Type=ttRSquareBracket) then
  begin
    header:=THeaderNode.Create;
    header.Value:=tokenList.Items[1]^.Value;

    case IndexStr(UpperCase(tokenList.Items[1]^.Value),
            [UpperCase(requestDefinition.Header),
             UpperCase(policyDefinition.Header),
             UpperCase(roleDefinition.Header),
             UpperCase(policyEffectDefinition.Header),
             UpperCase(matchersDefinition.Header)
            ]) of
      0: header.SectionType:=stRequestDefinition;
      1: header.SectionType:=stPolicyDefinition;
      2: header.SectionType:=stRoleDefinition;
      3: header.SectionType:=stPolicyEffect;
      4: header.SectionType:=stMatchers;
    else
      header.SectionType:=stUnknown;
    end;
    attachTo.ChildNodes.Add(header);
  end;



//
//
//  New(buffer);
//  FillChar(buffer, SizeOf(TTokenBuf), #0);
//
//  for i:=0 to tokenList.Count-1 do
//  begin
//    FillChar(buffer, SizeOf(TTokenBuf), #0);
//    token:=nil;
//
//    buffer.Previous:=nil;
//    if i-1>=0 then
//    begin
//      token:=tokenList.Items[i-1];
//      if not token^.IsDeleted then
//        buffer.Previous:=token;
//    end;
//
//    token:=tokenList.Items[i];
//    if not token^.isDeleted then
//      buffer.Current:=token;
//
//    buffer.Next:=nil;
//    if i+1<=tokenList.Count-1 then
//    begin
//      token:=tokenList.Items[i+1];
//      if not token^.IsDeleted then
//        buffer.Next:=token;
//    end;
//
//    if Assigned(buffer.Current) then
//    begin
//      case buffer.Current^.&Type of
//        ttIdentifier: begin
//                        //Check if we are in header
//                        if Assigned(buffer.Previous) then
//                        begin
//                          case buffer.Previous^.&Type of
//                            ttLSquareBracket: begin
//                              //We are inside the header
//
//                                              end;
//                          end;
//                        end;
//                      end;
//
//      end;
//    end;
//  end;
//
//  Dispose(buffer);
end;

end.
