unit DAO.Connection;

interface

uses System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
Data.DB, FireDAC.Comp.Client, System.IniFiles, FireDAC.Phys.FBDef,
FireDAC.Phys.IBBase, FireDAC.Phys.FB;

type
  TConnection = class
    private

    public
      class procedure CarregarConfig(Connection: TFDConnection);
      class function CreateConnection: TFDConnection;
  end;

Const
  ARQ_INI = 'C:\Users\Robert Silva\OneDrive\Documentos\GitHub\99Club\APIGO\DAO\config\Config.ini';

implementation

class function TConnection.CreateConnection: TFDConnection;
var
  Conn: TFDConnection;
begin
   Conn := TFDConnection.Create(nil);
   CarregarConfig(Conn);
   result := Conn;
end;

class procedure TConnection.CarregarConfig(Connection: TFDConnection);
var
  ini: TIniFile;
begin
  try
    //Instanciando o arquivo .ini
    ini := TIniFile.Create(ARQ_INI);
    Connection.DriverName := ini.ReadString('Banco de Dados', 'DriverID', '');

    //Carregando Configurações do arquivo
    with Connection.Params do
    begin
      Clear;
      Add('DriverID=' + ini.ReadString('Banco de Dados', 'DriverID', ''));
      Add('Database=' + ini.ReadString('Banco de Dados', 'Database', ''));
      Add('User_Name=' + ini.ReadString('Banco de Dados', 'User_Name', ''));
      Add('Password=' + ini.ReadString('Banco de Dados', 'Password', ''));
      Add('Protocol=TCPIP');

      if ini.ReadString('Banco de Dados', 'Server', '') <> '' then
        Add('Server=' + ini.ReadString('Banco de Dados', 'Server', ''));

      if ini.ReadString('Banco de Dados', 'Port', '') <> '' then
        Add('Port=' + ini.ReadString('Banco de Dados', 'Port', ''));

    end;
  finally
    if Assigned(ini) then
      ini.Free;
  end;
end;

end.
