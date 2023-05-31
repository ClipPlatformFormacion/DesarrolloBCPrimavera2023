report 50100 "CLIP Courses"
{
    Caption = 'Courses List', comment = 'ESP="Listado de Cursos"';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Course; "CLIP Course")
        {
            RequestFilterFields = "No.", "Language Code";
            // column(ColumnName; SourceFieldName)
            // {

            // }

            dataitem("CLIP Course Edition"; "CLIP Course Edition")
            {
                DataItemTableView = sorting("Course No.", Edition) order(ascending);
                DataItemLinkReference = Course;
                DataItemLink = "Course No." = field("No.");

                trigger OnAfterGetRecord()
                begin
                    Counter += 1;
                end;

                trigger OnPostDataItem()
                begin
                    CounterEdition += 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Counter += 1;
            end;

            trigger OnPostDataItem()
            begin
                Message('Cursos: ' + Format(Counter));
                Message('Ediciones: ' + Format(CounterEdition));
            end;
        }
    }

    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 field(Name; SourceExpression)
    //                 {
    //                     ApplicationArea = All;

    //                 }
    //             }
    //         }
    //     }
    // }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = RDLC;
    //         LayoutFile = 'mylayout.rdl';
    //     }
    // }

    var
        Counter: Integer;
        CounterEdition: Integer;
}