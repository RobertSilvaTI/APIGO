unit Controller.Auth;

interface

uses
  Horse,
  Horse.JWT,
  JOSE.Core.JWT,
  JOSE.Types.JSON,
  JOSE.Core.Builder,
  System.JSON,
  System.SysUtils;

const
  SECRET = 'Pasmado#1';

type
  TAuth = class(TJWTClaims)
    strict private
       function GetIDUser: integer;
       procedure SetIDUser(const Value: integer);
    public
       property ID_USUARIO: integer read GetIDUser write SetIDUser;
  end;

function GerarToken(id_usuario: integer): string;
function GetUserRequest(Req: THorseRequest): integer;

implementation

{ TAuth }

function GerarToken(id_usuario: integer): string;
var
  jwt: TJWT;
  claims: TAuth;
begin
  try
    jwt := TJWT.Create();
    claims := TAuth(jwt.Claims);

    try
      claims.ID_USUARIO := id_usuario;

      Result := TJOSE.SHA256CompactToken(SECRET, jwt);
    except
      Result := '';
    end;

  finally
    FreeAndNil(jwt);
  end;
end;

function GetUserRequest(Req: THorseRequest): integer;
var
  claims: TAuth;
begin
  claims := Req.Session<TAuth>;
  Result := claims.ID_USUARIO;
end;

function TAuth.GetIDUser: integer;
begin
  Result := FJSON.GetValue<integer>('id', 0);
end;

procedure TAuth.SetIDUser(const Value: integer);
begin
  TJSONUtils.SetJSONValueFrom<integer>('id', Value, FJSON);
end;

end.
