unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TFrmPrincipal = class(TForm)
    memo: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}
uses
  Horse,
  Horse.Jhonson,
  Horse.Compression,
  Controller.Categoria,
  Controller.Usuario,
  Controller.Cidade;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  THorse.Use(Compression());
  THorse.Use(Jhonson());

  // Rotas
  Controller.Categoria.RotaAPI;
  Controller.Usuario.RotaAPI;
  Controller.Cidade.RotaAPI;

  THorse.Listen(8082);

  memo.Lines.Add('Servidor executando na porta: ' + THorse.Port.ToString + '!');
end;

end.
