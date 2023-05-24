table 50104 "CLIP Course Journal Line"
{
    Caption = 'Course Journal Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                TestField("Posting Date");
            end;
        }
        field(6; "Course No."; Code[20])
        {
            Caption = 'Course No.';
            TableRelation = "CLIP Course";

            trigger OnValidate()
            begin
                Course.Get("Course No.");
                Description := Course.Name;
                "Unit Price" := Course.Price;
            end;
        }
        field(7; "Course Edition"; Code[20])
        {
            Caption = 'Course Edition';
            TableRelation = "CLIP Course Edition".Edition;
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                Validate("Unit Price");
            end;
        }
        field(16; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                "Total Price" := Quantity * "Unit Price";
            end;
        }
        field(17; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';

            trigger OnValidate()
            begin
                TestField(Quantity);
                GetGLSetup();
                "Unit Price" := Round("Total Price" / Quantity, GeneralLedgerSetup."Unit-Amount Rounding Precision");
            end;
        }
        field(23; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            // TableRelation = "Res. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(34; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }


    var
        Course: Record "CLIP Course";
        GeneralLedgerSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;

    procedure CopyDocumentFields(DocNo: Code[20]; ExtDocNo: Text[35]; SourceCode: Code[10]; NoSeriesCode: Code[20])
    begin
        "Document No." := DocNo;
    end;

    procedure CopyFromSalesHeader(SalesHeader: Record "Sales Header")
    begin
        "Posting Date" := SalesHeader."Posting Date";

        OnAfterCopyCourseJournalLineFromSalesHeader(SalesHeader, Rec);
    end;

    procedure CopyFromSalesLine(SalesLine: Record "Sales Line")
    begin
        "Course No." := SalesLine."No.";
        "Course Edition" := SalesLine."CLIP Course Edition";
        Description := SalesLine.Description;
        "Customer No." := SalesLine."Sell-to Customer No.";
        Quantity := -SalesLine."Qty. to Invoice";
        "Unit Price" := SalesLine."Unit Price";
        "Total Price" := -SalesLine.Amount;

        OnAfterCopyCourseJournalLineFromSalesLine(SalesLine, Rec);
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GeneralLedgerSetup.Get();
        GLSetupRead := true;
    end;

    procedure EmptyLine(): Boolean
    begin
        exit(("Course No." = '') and (Quantity = 0));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyCourseJournalLineFromSalesHeader(var SalesHeader: Record "Sales Header"; var CourseJournalLine: Record "CLIP Course Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyCourseJournalLineFromSalesLine(var SalesLine: Record "Sales Line"; var CourseJournalLine: Record "CLIP Course Journal Line")
    begin
    end;
}

