program Laba;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {Djilb};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDjilb, Djilb);
  Application.Run;
end.
