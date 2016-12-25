program bTiptopS;

uses
  Forms,
  bts in 'bts.pas' {frmServer};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmServer, frmServer);
  Application.Run;
end.
