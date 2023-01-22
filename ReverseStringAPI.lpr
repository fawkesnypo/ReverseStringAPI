program ReverseStringAPI;

{$mode objfpc}{$H+}

uses
    {$IFDEF UNIX}cthreads, cmem,{$ENDIF} sysutils, fphttpapp, httpdefs,
    httproute, fpjson, jsonparser;

procedure response(res:TResponse; status:Integer;responseContent:TJSONObject);
begin
  try
    res.Content := responseContent.AsJSON;
    res.Code := status;
    res.ContentType := 'application/json';
    res.ContentLength := length(res.Content);
    res.SendContent;
  finally
    responseContent.Free;
  end;
end;

begin
  Application.Port := 9080;
  HTTPRouter.RegisterRoute('/', rmGet,@timeRequest, true);
  Application.Threaded := true;
  Application.Initialize;
  Application.Run;
end.
