program APIGO;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  DAO.Connection in 'DAO\DAO.Connection.pas',
  DAO.Banner in 'DAO\DAO.Banner.pas',
  DAO.Categoria in 'DAO\DAO.Categoria.pas',
  DAO.Cidade in 'DAO\DAO.Cidade.pas',
  DAO.Cupom in 'DAO\DAO.Cupom.pas',
  DAO.Destaque in 'DAO\DAO.Destaque.pas',
  DAO.Estabelecimento in 'DAO\DAO.Estabelecimento.pas',
  DAO.Pedido in 'DAO\DAO.Pedido.pas',
  DAO.PedidoItem in 'DAO\DAO.PedidoItem.pas',
  DAO.PedidoItemDetalhe in 'DAO\DAO.PedidoItemDetalhe.pas',
  DAO.Produto in 'DAO\DAO.Produto.pas',
  DAO.Usuario in 'DAO\DAO.Usuario.pas',
  DAO.UsuarioEndereco in 'DAO\DAO.UsuarioEndereco.pas',
  DAO.UsuarioFavorito in 'DAO\DAO.UsuarioFavorito.pas',
  Controller.Categoria in 'Controller\Controller.Categoria.pas',
  Controller.Auth in 'Controller\Controller.Auth.pas',
  Controller.Usuario in 'Controller\Controller.Usuario.pas',
  Controller.Comum in 'Controller\Controller.Comum.pas',
  Controller.Cidade in 'Controller\Controller.Cidade.pas',
  Controller.Banner in 'Controller\Controller.Banner.pas',
  Controller.Cupom in 'Controller\Controller.Cupom.pas',
  Controller.Destaque in 'Controller\Controller.Destaque.pas';

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
