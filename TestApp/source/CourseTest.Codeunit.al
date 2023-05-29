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
        LibraryAssert: Codeunit "Library Assert";
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
        LibraryAssert.AreEqual(Value2, Result, 'El resultado no es el correcto');
    end;

    [Test]
    procedure CourseSalesTest001()
    var
        Course: Record "CLIP Course";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        LibrarySales: Codeunit "Library - Sales";
        LibraryAssert: Codeunit "Library Assert";
        LibraryCourse: Codeunit "CLIP Library - Course";
    begin
        // [Scenario] Cuando se selecciona un curso en una línea de un documento de venta,
        //              el sistema rellena la información relacionada con el curso

        // [Given] Un curso y un documento de venta
        LibraryCourse.CreateCourse(Course);

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);

        // [When] seleccionamos el curso en la línea de venta
        SalesLine.Validate(Type, "Sales Line Type"::"CLIP Course");
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Modify();

        // [Then] la línea de venta tiene Descripción, grupos contables y precio correctos
        LibraryAssert.AreEqual(Course.Name, SalesLine.Description, 'La descripción no es correcta');
        LibraryAssert.AreEqual(Course.Price, SalesLine."Unit Price", 'El precio no es correcto');
        LibraryAssert.AreEqual(Course."Gen. Prod. Posting Group", SalesLine."Gen. Prod. Posting Group", 'El grupo contable no es correcto');
        LibraryAssert.AreEqual(Course."VAT Prod. Posting Group", SalesLine."VAT Prod. Posting Group", 'El grupo contable no es correcto');
    end;

    [Test]
    procedure EditionIsFilledInPostedDocuments()
    var
        Course: Record "CLIP Course";
        CourseEdition: Record "CLIP Course Edition";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        LibrarySales: Codeunit "Library - Sales";
        LibraryAssert: Codeunit "Library Assert";
        LibraryCourse: Codeunit "CLIP Library - Course";
    begin
        // [Scenario] Cuando se registra un documento de venta, la información de la edición de curso seleccionada por el usuario
        //            queda guardada en los documentos registrados (albarán)

        // [Given] Un curso con una edición y un documento de venta para el curso y edición
        LibraryCourse.CreateCourse(Course);
        CourseEdition := LibraryCourse.CreateEdition(Course."No.");

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        SalesLine.Validate(Type, "Sales Line Type"::"CLIP Course");
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("CLIP Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, 1);
        SalesLine.Modify();

        // [When] se registra el albarán de venta
        LibrarySales.PostSalesDocument(SalesHeader, true, false);

        // [Then] la edición en el albarán es la correcta
        SalesShipmentLine.SetRange("Order No.", SalesLine."Document No.");
        SalesShipmentLine.SetRange("Order Line No.", SalesLine."Line No.");
        SalesShipmentLine.FindLast();

        LibraryAssert.AreEqual(SalesLine."CLIP Course Edition", SalesShipmentLine."CLIP Course Edition", 'La edición en el albarán no es correcta');
    end;

    [Test]
    procedure CourseLedgerEntriesAreCreated()
    var
        Course: Record "CLIP Course";
        CourseEdition: Record "CLIP Course Edition";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CourseLedgerEntry: Record "CLIP Course Ledger Entry";
        LibrarySales: Codeunit "Library - Sales";
        LibraryAssert: Codeunit "Library Assert";
        LibraryCourse: Codeunit "CLIP Library - Course";
        PostedDocumentNo: Code[20];
    begin
        // [Scenario] Al registrar una factura de venta de un curso y edición, se generan movimientos de curso

        // [Given] Un curso con una edición y un documento de venta para el curso y edición
        LibraryCourse.CreateCourse(Course);
        CourseEdition := LibraryCourse.CreateEdition(Course."No.");

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        SalesLine.Validate(Type, "Sales Line Type"::"CLIP Course");
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("CLIP Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, 1);
        SalesLine.Modify();

        // [When] se registra la factura de venta
        PostedDocumentNo := LibrarySales.PostSalesDocument(SalesHeader, true, true);

        // [Then] el movimiento de curso es correcto
        CourseLedgerEntry.SetRange("Document No.", PostedDocumentNo);
        LibraryAssert.AreEqual(1, CourseLedgerEntry.Count(), 'El nº de movimientos creados es incorrecto');

        CourseLedgerEntry.FindFirst();
        LibraryAssert.AreEqual(PostedDocumentNo, CourseLedgerEntry."Document No.", 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesHeader."Posting Date", CourseLedgerEntry."Posting Date", 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesLine."No.", CourseLedgerEntry."Course No.", 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesLine."CLIP Course Edition", CourseLedgerEntry."Course Edition", 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesLine.Description, CourseLedgerEntry.Description, 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesLine."Qty. to Invoice", CourseLedgerEntry.Quantity, 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesLine."Unit Price", CourseLedgerEntry."Unit Price", 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesLine."Qty. to Invoice" * SalesLine."Unit Price", CourseLedgerEntry."Total Price", 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesHeader."Sell-to Customer No.", CourseLedgerEntry."Customer No.", 'Datos incorrectos');
    end;

    [Test]
    procedure CourseLedgerEntriesAreCreatedForCreditMemo()
    var
        Course: Record "CLIP Course";
        CourseEdition: Record "CLIP Course Edition";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CourseLedgerEntry: Record "CLIP Course Ledger Entry";
        LibrarySales: Codeunit "Library - Sales";
        LibraryAssert: Codeunit "Library Assert";
        LibraryCourse: Codeunit "CLIP Library - Course";
        PostedDocumentNo: Code[20];
    begin
        // [Scenario] Al registrar una factura de venta de un curso y edición, se generan movimientos de curso

        // [Given] Un curso con una edición y un documento de venta para el curso y edición
        LibraryCourse.CreateCourse(Course);
        CourseEdition := LibraryCourse.CreateEdition(Course."No.");

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::"Return Order", '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        SalesLine.Validate(Type, "Sales Line Type"::"CLIP Course");
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("CLIP Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, 1);
        SalesLine.Modify();

        // [When] se registra la factura de venta
        PostedDocumentNo := LibrarySales.PostSalesDocument(SalesHeader, true, true);

        // [Then] el movimiento de curso es correcto
        CourseLedgerEntry.SetRange("Document No.", PostedDocumentNo);
        LibraryAssert.AreEqual(1, CourseLedgerEntry.Count(), 'El nº de movimientos creados es incorrecto');

        CourseLedgerEntry.FindFirst();
        LibraryAssert.AreEqual(PostedDocumentNo, CourseLedgerEntry."Document No.", 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesHeader."Posting Date", CourseLedgerEntry."Posting Date", 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesLine."No.", CourseLedgerEntry."Course No.", 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesLine."CLIP Course Edition", CourseLedgerEntry."Course Edition", 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesLine.Description, CourseLedgerEntry.Description, 'Datos incorrectos');
        LibraryAssert.AreEqual(-SalesLine."Qty. to Invoice", CourseLedgerEntry.Quantity, 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesLine."Unit Price", CourseLedgerEntry."Unit Price", 'Datos incorrectos');
        LibraryAssert.AreEqual(-(SalesLine."Qty. to Invoice" * SalesLine."Unit Price"), CourseLedgerEntry."Total Price", 'Datos incorrectos');
        LibraryAssert.AreEqual(SalesHeader."Sell-to Customer No.", CourseLedgerEntry."Customer No.", 'Datos incorrectos');
    end;

    [Test]
    [HandlerFunctions('MaxStudentCheck')]
    procedure CourseSalesChecksMaxStudents()
    var
        Course: Record "CLIP Course";
        CourseEdition: Record "CLIP Course Edition";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CourseLedgerEntry: Record "CLIP Course Ledger Entry";
        LibrarySales: Codeunit "Library - Sales";
        LibraryAssert: Codeunit "Library Assert";
        LibraryCourse: Codeunit "CLIP Library - Course";
        PostedDocumentNo: Code[20];
    begin
        // [Scenario] Cuando se intenta hacer una venta que supera el número máximo de alumnos
        //              permitidos para una edición, el sistema muestra un mensaje de aviso al usuario

        // [Given] Un curso y edición con 2 ventas previas
        LibraryCourse.CreateCourse(Course);
        CourseEdition := LibraryCourse.CreateEdition(Course."No.");

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        SalesLine.Validate(Type, "Sales Line Type"::"CLIP Course");
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("CLIP Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, 3);
        SalesLine.Modify();
        LibrarySales.PostSalesDocument(SalesHeader, true, true);

        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        SalesLine.Validate(Type, "Sales Line Type"::"CLIP Course");
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("CLIP Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, 2);
        SalesLine.Modify();
        LibrarySales.PostSalesDocument(SalesHeader, true, true);

        // [When] Se hace una nueva venta (que supera el máximo de alumnos)
        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::Order, '');
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        SalesLine.Validate(Type, "Sales Line Type"::"CLIP Course");
        SalesLine.Validate("No.", Course."No.");
        SalesLine.Validate("CLIP Course Edition", CourseEdition.Edition);
        SalesLine.Validate(Quantity, CourseEdition."Max. Students" - 4);
        SalesLine.Modify();

        // [Then] El sistema tiene que mostrar una notificación
    end;

    [MessageHandler]
    procedure MaxStudentCheck(Message: Text[1024])
    var
        LibraryAssert: Codeunit "Library Assert";
    begin
        if not Message.Contains('superará el número máximo de alumnos') then
            Error('El Message no es el correcto: %1', Message);
    end;
}