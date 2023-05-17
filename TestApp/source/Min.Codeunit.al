codeunit 50141 "CLIP Min"
{
    procedure GetMin(v1: Decimal; v2: Decimal): Decimal
    begin
        // if v1 < v2 then
        //     exit(v1)
        // else
        //     exit(v2);

        // if v1 > v2 then
        //     exit(v2)
        // else
        //     exit(v1);

        if v1 <= v2 then
            exit(v1);
        exit(v2);
    end;
}