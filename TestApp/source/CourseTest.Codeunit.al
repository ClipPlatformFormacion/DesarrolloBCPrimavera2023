codeunit 50140 "CLIP Course Test"
{
    Subtype = Test;

    [Test]
    procedure Test000()
    begin

    end;

    [Test]
    procedure Test001()
    var
        CLIPMin: Codeunit "CLIP Min";
        Value1, Value2 : Decimal;
        Result: Decimal;
    begin
        // [Scenario] Una función llamada GetMin devuelve el mínimo de 2 valores numéricos

        // [Given] 2 valores numéricos (4 y 6)
        Value1 := 4;
        Value2 := 6;

        // [When] al llamar a la función GetMin
        Result := CLIPMin.GetMin(Value1, Value2);

        // [Then] El resultado es 4
        if Result <> Value1 then
            Error('El resultado no es el correcto');
    end;

    [Test]
    procedure Test002()
    var
        CLIPMin: Codeunit "CLIP Min";
        Value1, Value2 : Decimal;
        Result: Decimal;
    begin
        // [Scenario] Una función llamada GetMin devuelve el mínimo de 2 valores numéricos

        // [Given] 2 valores numéricos (4 y 6)
        Value1 := 6;
        Value2 := 4;

        // [When] al llamar a la función GetMin
        Result := CLIPMin.GetMin(Value1, Value2);

        // [Then] El resultado es 4
        if Result <> Value2 then
            Error('El resultado no es el correcto');
    end;
}