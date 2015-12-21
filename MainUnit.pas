unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RegExpr, math;

type
  TDjilb = class(TForm)
    MemoCode: TMemo;
    ButtonLoadFrom: TButton;
    ButtonMakeGood: TButton;
    OpenDialogFileCode: TOpenDialog;
    LabelResult: TLabel;
    procedure ButtonLoadFromClick(Sender: TObject);
    procedure ButtonMakeGoodClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
Pointer = ^stack;
stack = Record
   element : string;
   next : pointer;
end;

var
  Djilb: TDjilb;
  RegExpr : TRegExpr;
  operators : string;
  upStack : pointer;

implementation

{$R *.dfm}

procedure DeleteElement( Var Code:string);
begin
  regExpr.Expression:='"(/\*)|(\*/)"';
  Code:=regExpr.Replace(Code,'"___"');
end;

procedure DeleteComment(var code : string);
begin
  regExpr.ModifierM:= True;
  regExpr.Expression:='//.*?$';
  Code:= regExpr.Replace(Code,'');
  regExpr.ModifierS:= True;
  regExpr.Expression:='/\*.*?\*/';
  Code:= regExpr.Replace(Code,'');
  regExpr.ModifierS:= False;
end;

procedure DeleteString(var code : string);
begin
  regExpr.Expression:='''.?''';
  Code:= regExpr.Replace(Code,'''''');
  regExpr.Expression:='".*?"';
  Code:= regExpr.Replace(Code,'""');
end;

procedure TDjilb.ButtonLoadFromClick(Sender: TObject);
begin
   if OpenDialogFileCode.Execute then
      MemoCode.Lines.LoadFromFile(OpenDialogFileCode.FileName);
end;

procedure PushStack(temp : string);
var
   nowStack : pointer;
begin
   new(nowStack);
   nowStack^.next := upStack;
   nowStack^.element := temp;
   upStack := nowStack;
end;

function PopStack( var linker : integer):integer;
var
   nowStack : pointer;
begin
   result := 0;
   repeat
      if (upStack^.element = 'if') or (upStack^.element = 'else') then
      begin
         inc(result);
      end;
      nowStack := upStack^.next;
     // showmessage(upStack^.element);
      Dispose(upStack);
      upStack := nowStack;
   until ((upStack = nil) or (upStack^.element = '{'));
   nowStack := upStack;
   while (nowStack <> nil) do
   begin
      if (nowStack^.element = 'if') or (nowStack^.element = 'else') then
         inc(result);
      nowStack := nowStack^.next;
   end;
end;

procedure TDjilb.ButtonMakeGoodClick(Sender: TObject);
var
   ifCounter : integer;
   elseCounter : integer;
   operatorCounter : integer;
   nestingIF, maxNesting, linker: integer;
   i : integer;
   nowStack : pointer;
   codeLine : string;
begin
   operators := '(if|switch|for|while|do|break|continue|return|goto|case|else|'; ;
   operators := operators + '(\=)|(\+)|(\*)|(\/)|(\-)|(\>)|(\<)|(\+\+)|(\-\-)|(\=\=))';
   //MemoCode.Lines.Text := UpperCase(MemoCode.Lines.Text);
   upStack := nil;
   nestingIF := 0;
   linker := 1;
   maxNesting := 0;
   operatorCounter := 0;
   ifCounter := 0;
   elseCounter := 0;
   RegExpr := TRegExpr.Create;

   for i := 0 to MemoCode.Lines.Count - 1 do
   begin
      codeLine := MemoCode.Lines[i];
      DeleteComment(codeLine);

      DeleteString(codeLine);
      MemoCode.Lines[i] := codeLine;
      RegExpr.Expression := '(\bif * +\(|\belse\b)';
      if RegExpr.Exec(MemoCode.Lines[i]) then
      begin
         inc(ifCounter);
         PushStack('if');
         inc(elseCounter);

         if not RegExpr.Exec(MemoCode.Lines[i + 1]) then
         begin
            RegExpr.Expression := '{';
            if not RegExpr.Exec(MemoCode.Lines[i + 1]) then
            begin
               nestingIF := PopStack(linker);
               if nestingIF > maxNesting then
                  maxNesting := nestingIF;
            end;
         end;
      end;
       RegExpr.Expression := '{';
      if RegExpr.Exec(MemoCode.Lines[i]) and (upStack <> nil) then
      begin
         PushStack('{');
      end;
        RegExpr.Expression := '}';
      if RegExpr.Exec(MemoCode.Lines[i]) and (upStack <> nil) then
      begin
         nestingIF := PopStack(linker);
         if nestingIF > maxNesting then
            maxNesting := nestingIF;;
      end;
      
      RegExpr.Expression := '\W*' + operators + '\W*';
      if RegExpr.Exec(MemoCode.Lines[i]) then
      repeat
         inc(operatorCounter);
      until not RegExpr.ExecNext
   end;
   if operatorCounter = 0 then
      operatorCounter := 1;
   LabelResult.Caption := 'Абсолютная сложность = ' + inttostr(ifCounter)  + ' Количество операторов = ' + intToStr(operatorCounter) +' Относительная сложность = ' + floattostr(Round(ifCounter / operatorCounter * 100) / 100 ) + ' Максимальная вложенность = ' + inttostr(maxNesting);
end;
end.
