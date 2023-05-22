permissionset 50100 "CLIP Courses"
{
    Caption = 'Courses', Comment = 'ESP="Cursos"';
    Assignable = true;
    Permissions =
        tabledata "CLIP Course" = RIMD,
        tabledata "CLIP Course Edition" = RIMD,
        tabledata "CLIP Courses Setup" = RIMD,
        table "CLIP Course" = X,
        table "CLIP Course Edition" = X,
        table "CLIP Courses Setup" = X,
        page "CLIP Course Card" = X,
        page "CLIP Course Editions" = X,
        page "CLIP Course Editions FactBox" = X,
        page "CLIP Course List" = X,
        page "CLIP Courses Setup" = X,
        table "CLIP Course Ledger Entry" = X,
        tabledata "CLIP Course Ledger Entry" = RMID,
        codeunit "CLIP Course - Sales Management" = X,
        page "CLIP Course Ledger Entries" = X;
}