table 50102 "CLIP Course Edition"
{
    Caption = 'Course Edition', Comment = 'ESP="Edición curso"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Course No."; Code[20])
        {
            Caption = 'Course No.', Comment = 'ESP="Nº curso"';
            TableRelation = "CLIP Course";
        }
        field(2; Edition; Code[20])
        {
            Caption = 'Edition', Comment = 'ESP="Edición"';
        }
        field(3; "Start Date"; Date)
        {
            Caption = 'Start Date', Comment = 'ESP="Fecha inicio"';
        }
        field(4; "Max. Students"; Integer)
        {
            Caption = 'Max. Students', Comment = 'ESP="Nº máx. alumnos"';
            BlankZero = true;
        }
        field(10; "Sales (Qty.)"; Decimal)
        {
            Caption = 'Sales (Qty.)', comment = 'ESP="Ventas (cdad.)"';
            Editable = false;
            DecimalPlaces = 0 : 5;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = sum("CLIP Course Ledger Entry".Quantity
                                where("Course No." = field("Course No."),
                                        "Course Edition" = field(Edition),
                                        "Posting Date" = field("Date Filter")
                                    )
                               );
        }
        field(11; "Date Filter"; Date)
        {
            Caption = 'Date Filter', comment = 'ESP="Filtro fecha"';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(PK; "Course No.", Edition)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Edition, "Start Date", "Max. Students") { }
    }
}