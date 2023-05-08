page 50105 "CLIP Application Areas"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Application Area Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Advanced; Rec.Advanced)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}