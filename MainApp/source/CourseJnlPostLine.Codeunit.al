codeunit 50101 "CLIP Course Jnl.-Post Line"
{
    Permissions = TableData "CLIP Course Ledger Entry" = imd;
    TableNo = "CLIP Course Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        CourseJournalLine: Record "CLIP Course Journal Line";
        CourseLedgerEntry: Record "CLIP Course Ledger Entry";
        NextEntryNo: Integer;

    procedure RunWithCheck(var CourseJournalLine2: Record "CLIP Course Journal Line")
    begin
        CourseJournalLine.Copy(CourseJournalLine2);
        Code();
        CourseJournalLine2 := CourseJournalLine;
    end;

    local procedure "Code"()
    begin
        OnBeforePostCourseJournalLine(CourseJournalLine);

        if CourseJournalLine.EmptyLine() then
            exit;

        if NextEntryNo = 0 then begin
            CourseLedgerEntry.LockTable();
            NextEntryNo := CourseLedgerEntry.GetLastEntryNo() + 1;
        end;

        CourseLedgerEntry.Init();
        CourseLedgerEntry.CopyFromCourseLine(CourseJournalLine);

        CourseLedgerEntry."Total Price" := Round(CourseLedgerEntry."Total Price");
        CourseLedgerEntry."Entry No." := NextEntryNo;

        OnBeforeCourseLedgerEntryInsert(CourseLedgerEntry, CourseJournalLine);

        CourseLedgerEntry.Insert(true);

        NextEntryNo := NextEntryNo + 1;

        OnAfterPostCourseJournalLine(CourseJournalLine, CourseLedgerEntry);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostCourseJournalLine(var CourseJournalLine: Record "CLIP Course Journal Line"; var CourseLedgerEntry: Record "CLIP Course Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostCourseJournalLine(var CourseJournalLine: Record "CLIP Course Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCourseLedgerEntryInsert(var CourseLedgerEntry: Record "CLIP Course Ledger Entry"; CourseJournalLine: Record "CLIP Course Journal Line")
    begin
    end;
}

