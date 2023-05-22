table 50103 "CLIP Course Ledger Entry"
{
    Caption = 'Course Ledger Entry', Comment = 'ESP="Mov. Curso"';
    DrillDownPageID = "Resource Ledger Entries";
    LookupPageID = "Resource Ledger Entries";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Course No."; Code[20])
        {
            Caption = 'Course No.';
            TableRelation = "CLIP Course";
        }
        field(6; "Course Edition"; Code[20])
        {
            Caption = 'Course Edition';
            TableRelation = "CLIP Course Edition".Edition;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(15; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(16; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
        }
        field(31; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", Description, "Document No.", "Posting Date")
        {
        }
    }

    procedure GetLastEntryNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Entry No.")))
    end;

    procedure CopyFromResJnlLine(ResJournalLine: Record "Res. Journal Line")
    begin
        "Document No." := ResJournalLine."Document No.";
        "Posting Date" := ResJournalLine."Posting Date";
        "Course No." := ResJournalLine."Resource No.";
        Description := ResJournalLine.Description;
        Quantity := ResJournalLine.Quantity;
        "Unit Price" := ResJournalLine."Unit Price";
        "Total Price" := ResJournalLine."Total Price";
        "Customer No." := ResJournalLine."Source No.";

        OnAfterCopyFromResJnlLine(Rec, ResJournalLine);
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCopyFromResJnlLine(var CourseLedgerEntry: Record "CLIP Course Ledger Entry"; ResJournalLine: Record "Res. Journal Line")
    begin
    end;
}

