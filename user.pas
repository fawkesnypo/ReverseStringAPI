unit User;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,md5;

type
  TUser = class(TObject)
    private
      username:string;
      password:string;
      token:string;
      function setToken(user:string;pass:string):string;
    public
      constructor Create(user:string;pass:string);
      function getToken():string;
  end;

implementation

constructor TUser.Create(user:string;pass:string);
begin
  username:=user;
  password:=pass;
  token := setToken(user,pass);
end;

function TUser.setToken(user:string;pass:string):string;
begin
  Result := MD5Print(MD5String(user+pass));
end;

function TUser.getToken:string;
begin
  Result := token;
end;

end.

