program ReverseStringAPI;

{$mode objfpc}{$H+}

uses
    {$IFDEF UNIX}cthreads, cmem,{$ENDIF} sysutils, fphttpapp, httpdefs,
    httproute, fpjson, jsonparser,User,StrUtils;

var
   us:TUser;

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

procedure createUser(req: TRequest; res:TResponse);
var
  jData : TJSONData;
  jObject,jObjectResponse: TJSONObject;
begin
  jObjectResponse := TJSONObject.Create;
  if (Length(req.content) > 0) and (not Assigned(us)) then
    begin
        jData := GetJSON(req.Content);
        jObject := jData as TJSONObject;

        if (Length(jObject.Get('user')) > 0) and (Length(jObject.Get('pass')) > 0) then
          begin
              us := TUser.Create(jObject.Get('user'),jObject.Get('pass'));
              jObjectResponse.Strings['token'] := us.getToken();
              response(res,200,jObjectResponse);
              jObject.Free;
              Exit;
          end
        else
            begin
              jObject.Free;
            end;
    end;

  if Assigned(us) then
    begin
        jObjectResponse.Strings['message'] := 'A linked user already exists, to link a new one release the previous one with the /user route as put!';
        response(res,400,jObjectResponse);
        Exit;
    end;

  jObjectResponse.Strings['message'] := 'Invalid Content!';
  jObjectResponse.Strings['content'] := req.Content;
  jObjectResponse.Strings['example'] := '{user:username,pass:password}';
  response(res,400,jObjectResponse);

end;

procedure updateUser(req:TRequest; res:TResponse);
var
  jData : TJSONData;
  jObject,jObjectResponse: TJSONObject;
begin
  jObjectResponse := TJSONObject.Create;
  if (Length(req.content) > 0) and (Assigned(us)) then
    begin
        jData := GetJSON(req.Content);
        jObject := jData as TJSONObject;

        if (Length(jObject.Get('user')) > 0) and (Length(jObject.Get('pass')) > 0) then
          begin
              us.Free;
              us := TUser.Create(jObject.Get('user'),jObject.Get('pass'));
              jObjectResponse.Strings['token'] := us.getToken();
              response(res,200,jObjectResponse);
              jObject.Free;
              Exit;
          end
        else
            begin
              jObject.Free;
            end;
    end;

  jObjectResponse.Strings['message'] := 'Invalid Content!';
  jObjectResponse.Strings['content'] := req.Content;
  jObjectResponse.Strings['example'] := '{user:username,pass:password}';
  response(res,400,jObjectResponse);

end;

procedure getUserToken(req:TRequest; res:TResponse);
var
   jObjectResponse: TJSONObject;
begin
  jObjectResponse := TJSONObject.Create;
  if Assigned(us) then
    begin
        jObjectResponse.Strings['token'] := us.getToken();
        response(res,200,jObjectResponse);
        Exit;
    end;

  jObjectResponse.Strings['message'] := 'No user linked, please use /user route as post to perform user link';
  response(res,403,jObjectResponse);
end;

procedure stringReverse(req:TRequest; res:TResponse);
var
  jData: TJSONData;
  jObject,jObjectResponse: TJSONObject;
begin
  jObjectResponse := TJSONObject.Create;
  if (Length(req.content) > 0) and (Assigned(us)) then
    begin
        jData := GetJSON(req.Content);
        jObject := jData as TJSONObject;

        if (Length(jObject.Get('string')) > 0) and (req.Authorization = us.getToken()) then
          begin
              jObjectResponse.Strings['reverseString'] := ReverseString(jObject.Get('string'));
              response(res,200,jObjectResponse);
              jObject.Free;
              Exit;
          end
        else
            begin
              jObject.Free;
            end;
    end;

  jObjectResponse.Strings['message'] := 'Unauthorized!';
  response(res,401,jObjectResponse);

end;

begin
  Application.Port := 9080;
  HTTPRouter.RegisterRoute('/', rmGet,@timeRequest, true);
  HTTPRouter.RegisterRoute('/user', rmPost,@createUser, false);
  HTTPRouter.RegisterRoute('/user', rmPut,@updateUser, false);
  HTTPRouter.RegisterRoute('/user', rmGet,@getUserToken, false);
  HTTPRouter.RegisterRoute('/string', rmPost,@stringReverse, false);
  Application.Threaded := true;
  Application.Initialize;
  Application.Run;
end.
