page 50106 "CLIP Query Execution"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    actions
    {
        area(Processing)
        {
            action(SimpleItemQuery)
            {
                Image = ExecuteBatch;
                ApplicationArea = All;
                RunObject = query "CLIP Simple Item Query";
            }
            action(ALQuery)
            {
                // RunObject = query "CLIP Simple Item Query";

                trigger OnAction()
                var
                    SimpleItemQuery: Query "CLIP Simple Item Query";
                    Counter: Integer;
                begin
                    SimpleItemQuery.SetFilter(SimpleItemQuery.Unit_Cost, '>100');
                    SimpleItemQuery.Open();

                    while SimpleItemQuery.Read() do
                        Counter += 1;

                    SimpleItemQuery.Close();

                    Message(Format(Counter));
                end;
            }
        }
    }
}