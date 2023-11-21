{us/mf/mfdtitle.i}
define temp-table tt_output
   field field_1  as character
   field field_2  as character
   field field_3  as character
   field field_4  as character
   field field_5  as character format "x(30)"
   field field_6  as character
   field field_7  as character
   field field_8  as character
   field field_9  as character format "x(30)"
   field field_10 as character format "x(30)"
   field field_11 as character
   field field_12 as character
   field field_13 as character
   field field_14 as character
   field field_15 as character
   field field_16 as character
   field field_17 as character format "x(30)"
   field field_18 as character
   field field_19 as character
   field field_20 as character
   field field_21 as character
   field field_22 as integer
.



define  variable v_entity_from         as character   format "x(30)"              no-undo.
define  variable v_entity_to           as character   format "x(30)"              no-undo.
define  variable v_piece_from          as character   format "x(30)"              no-undo.
define  variable v_piece_to            as character   format "x(30)"              no-undo.
define  variable v_four_from           as character   format "x(30)"              no-undo.
define  variable v_four_to             as character   format "x(30)"              no-undo.
define  variable v_datef_from          like CInvoice.CInvoiceDueDate                      no-undo.
define  variable v_datef_to            like CInvoice.CInvoiceDueDate                      no-undo.
define  variable v_datev_from          like CInvoice.CInvoiceDueDate                      no-undo.
define  variable v_datev_to            like CInvoice.CInvoiceDueDate                      no-undo.
define  variable v_rexp                as logical     initial  no   no-undo.
define  variable v_file                as character  format "x(60)"   no-undo.
define  variable v_op_path             as character                   no-undo.
define  variable v_file_sp             as character initial ";"       no-undo.
define  variable v_rexport             as     logical   initial  no           no-undo.



Form 
   v_entity_from     colon 12 label "Entite"
   v_entity_to       colon 47 label "A"
   v_piece_from      colon 12 label "Piece"
   v_piece_to        colon 47 label "A"
   v_four_from       colon 12 label "Fournisseur"
   v_four_to         colon 47 label "A"
   v_datef_from      colon 17 label "Date facturation"
   v_datef_to        colon 47 label "A"
   v_datev_from      colon 17 label "Date validite"
   v_datev_to        colon 47 label "A"
   v_rexp            colon 17 label "rexport"
   skip(1) // LINE BREAK
   v_file            colon 20 label "LIEN de L'EXPORT"

with Frame a side-labels width 80. 

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* SET EXTERNAL LABELS */
form
with frame reprint_frame down width 400.
/* SET EXTERNAL labelS */
setframelabels(frame reprint_frame:handle).

FUNCTION F_get_gn_parm returns character (input ip_fldname as character, 
                                       input ip_value   as character ):
      define variable v_path as character no-undo.

      v_path = "" .

      find first code_mstr 
      where code_domain   = global_domain
      and   code_fldname  = ip_fldname
      and   code_value    = "Yes"
      no-lock no-error.

      if available code_mstr then do : 
      v_path = code_cmmt + "/"  .
      return v_path.
      end. 
      else return v_path .
END FUNCTION.  /* F_get_gn_parm */  

/*
function F_Date_Format returns character (input ip_date as date) :              
                                                                           
   define variable v_date  as character no-undo.   
   define variable v_month   as character no-undo.

   if length(month(ip_date)) < 2 
   then  v_month = "0" + string(month(ip_date)).
   else  v_month = string(month(ip_date)).

   v_date = string(day(ip_date)) + "" +                                            
            v_month + "" +                                 
            substring(string(year(ip_date)), 3 , 2 )
         .  

   return v_date .   
                  
                                                
END FUNCTION. /*F_Date_Format*/
*/

function F_Date_Format returns character (input ip_date as date) :              
                                                                        
   define variable v_date    as character no-undo.   
   define variable v_month   as character no-undo.
   define variable v_day     as character no-undo.

   if   length(month(ip_date)) < 2 
   then  v_month = "0" + string(month(ip_date)).
   else  v_month = string(month(ip_date)).

   if   length(day(ip_date)) < 2 
   then  v_day = "0" + string(day(ip_date)).
   else  v_day = string(day(ip_date)).


   v_date = v_day   + "" +                                            
            v_month + "" +                                 
            substring(string(year(ip_date)), 3 , 2 )
         .  
   return v_date .   
                                                        
END FUNCTION. /*F_Date_Format*/


mainloop:
repeat:


   empty temp-table tt_output.

   if v_entity_to   = hi_char then v_entity_to   = "" .
   if v_piece_to   = hi_char then v_piece_to   = "" .
   if v_four_to   = hi_char then v_four_to   = "" .

   if v_datef_from   = low_date then v_datef_from   = ? .
   if v_datef_to   = hi_date then v_datef_to    = ? .
   if v_datev_from   = low_date then v_datev_from   = ? .
   if v_datev_to   = hi_date then v_datev_to    = ? .


   display v_file with frame a.
      update 
         v_entity_from     
         v_entity_to       
         v_piece_from      
         v_piece_to        
         v_four_from       
         v_four_to         
         v_datef_from
         v_datef_to
         v_datev_from
         v_datev_to
         v_rexp

   with frame a.

   assign
      v_op_path = ""
      v_file = "Pur_Interface_Sage_"
               + string(day(today),"99")                
               + string(month(today),"99")              
               + string(year(today),"9999")             
               + substring(string(time,"HH:MM:SS"),1,2) 
               + substring(string(time,"HH:MM:SS"),4,2) 
               + substring(string(time,"HH:MM:SS"),7,2) 
               + ".txt"
   .


   if v_entity_to  = ""  then v_entity_to  = hi_char  .
   if v_piece_to  = ""  then v_piece_to  = hi_char  .
   if v_four_to  = ""  then v_four_to  = hi_char  .

   if v_datef_from   = ? then v_datef_from   = low_date .
   if v_datef_to   = ? then v_datef_to    = hi_date .
   if v_datev_from   = ? then v_datev_from   = low_date .
   if v_datev_to   = ? then v_datev_to    = hi_date .

   v_op_path = F_get_gn_parm("Sage_Pur_Inter" , "Yes" ).

   if (v_op_path = "") then do:
      {us/bbi/pxmsg.i &MSGNUM=99158 &ERRORLEVEL=4}.
      next-prompt v_rexport with frame main_frame.
      undo mainloop, retry mainloop.
   end.

   if v_rexp = yes then run search_data(input "exp").
   else 
      run search_data(input "").

   
   v_file =  v_op_path +  v_file  .
   define buffer b_tt_output for tt_output.
   define stream file_csv.
   output stream file_csv to value (v_file).
   for each tt_output 
   break by field_22 :

      IF FIRST-OF(tt_output.field_22) then do:
      for each b_tt_output 
      where b_tt_output.field_22 = tt_output.field_22
      and b_tt_output.field_4 <> "V" 
      and b_tt_output.field_4 <> "X":

         put stream file_csv unformatted 
         b_tt_output.field_1    v_file_sp
         b_tt_output.field_2    v_file_sp
         b_tt_output.field_3    v_file_sp
         b_tt_output.field_4    v_file_sp
         b_tt_output.field_5    v_file_sp
         b_tt_output.field_6    v_file_sp
         b_tt_output.field_7    v_file_sp
         b_tt_output.field_8    v_file_sp
         b_tt_output.field_9    v_file_sp
         b_tt_output.field_10   v_file_sp
         b_tt_output.field_11   v_file_sp
         b_tt_output.field_12   v_file_sp
         b_tt_output.field_13   v_file_sp
         b_tt_output.field_14   v_file_sp
         b_tt_output.field_15   v_file_sp
         b_tt_output.field_16   v_file_sp
         b_tt_output.field_17   v_file_sp
         b_tt_output.field_18   v_file_sp
         b_tt_output.field_19   v_file_sp
         b_tt_output.field_20   v_file_sp
         b_tt_output.field_21    
         skip.
         
      end.

      for each b_tt_output 
      where b_tt_output.field_22 = tt_output.field_22
      and b_tt_output.field_4 = "V":

         put stream file_csv unformatted 
         b_tt_output.field_1    v_file_sp
         b_tt_output.field_2    v_file_sp
         b_tt_output.field_3    v_file_sp
         "G"                    v_file_sp
         b_tt_output.field_5    v_file_sp
         b_tt_output.field_6    v_file_sp
         b_tt_output.field_7    v_file_sp
         b_tt_output.field_8    v_file_sp
         b_tt_output.field_9    v_file_sp
         b_tt_output.field_10   v_file_sp
         b_tt_output.field_11   v_file_sp
         b_tt_output.field_12   v_file_sp
         b_tt_output.field_13   v_file_sp
         b_tt_output.field_14   v_file_sp
         b_tt_output.field_15   v_file_sp
         b_tt_output.field_16   v_file_sp
         b_tt_output.field_17   v_file_sp
         b_tt_output.field_18   v_file_sp
         b_tt_output.field_19   v_file_sp
         b_tt_output.field_20   v_file_sp
         b_tt_output.field_21    
         skip.
         
      end.

      for each b_tt_output 
      where b_tt_output.field_22 = tt_output.field_22
      and b_tt_output.field_4 = "X":

         put stream file_csv unformatted 
         b_tt_output.field_1    v_file_sp
         b_tt_output.field_2    v_file_sp
         b_tt_output.field_3    v_file_sp
         b_tt_output.field_4    v_file_sp
         b_tt_output.field_5    v_file_sp
         b_tt_output.field_6    v_file_sp
         b_tt_output.field_7    v_file_sp
         b_tt_output.field_8    v_file_sp
         b_tt_output.field_9    v_file_sp
         b_tt_output.field_10   v_file_sp
         b_tt_output.field_11   v_file_sp
         b_tt_output.field_12   v_file_sp
         b_tt_output.field_13   v_file_sp
         b_tt_output.field_14   v_file_sp
         b_tt_output.field_15   v_file_sp
         b_tt_output.field_16   v_file_sp
         b_tt_output.field_17   v_file_sp
         b_tt_output.field_18   v_file_sp
         b_tt_output.field_19   v_file_sp
         b_tt_output.field_20   v_file_sp
         b_tt_output.field_21    
         skip.
         
      end.



   end.
   end.
   


   output stream file_csv close.



end.


procedure add_row :

   define input parameter i_arr_line as character extent 23.
   

   create tt_output.

   tt_output.field_1  = i_arr_line[1].
   tt_output.field_2  = i_arr_line[2].
   tt_output.field_3  = i_arr_line[3].
   tt_output.field_4  = i_arr_line[4].
   tt_output.field_5  = i_arr_line[5].
   tt_output.field_6  = i_arr_line[6].
   tt_output.field_7  = i_arr_line[7].
   tt_output.field_8  = i_arr_line[8].
   tt_output.field_9  = i_arr_line[9].
   tt_output.field_10 = i_arr_line[10].
   tt_output.field_11 = i_arr_line[11].
   tt_output.field_12 = i_arr_line[12].
   tt_output.field_13 = i_arr_line[13].
   tt_output.field_14 = i_arr_line[14].
   tt_output.field_15 = i_arr_line[15].
   tt_output.field_16 = i_arr_line[16].
   tt_output.field_17 = i_arr_line[17].
   tt_output.field_18 = i_arr_line[18].
   tt_output.field_19 = i_arr_line[19].
   tt_output.field_20 = i_arr_line[20].
   tt_output.field_21 = i_arr_line[21].
   tt_output.field_22  = decimal(i_arr_line[22]).
 

end.
procedure search_data :

   define variable arr as character extent.
   define variable v_subaccount as character.
   define variable v_currency_code as character.
   define variable file_name as character.
   define variable arr_line as character extent 23.
   define variable num_line as integer initial 0.
   define input parameter i_exp as character.
   define buffer zz_cinvoice for CInvoice.
   define buffer xx_cinvoice for Cinvoice.


   define variable voucher_f as int.
   define variable voucher_t as int.

   define variable date_f as int.
   define variable date_t as int.

   define variable journal_f as character.
   define variable journal_t as character.

   if NUM-ENTRIES( v_piece_from,"/") > 2 then do:
   assign
      voucher_f = integer(ENTRY(3,v_piece_from,"/"))
      voucher_t = integer(ENTRY(3,v_piece_to,"/"))

      date_f = integer(ENTRY(1,v_piece_from,"/"))
      date_t = integer(ENTRY(1,v_piece_to,"/"))

      journal_f = string(ENTRY(2,v_piece_from,"/"))
      journal_t = string(ENTRY(2,v_piece_to,"/"))
   .
   end.
   else do:
      assign
      voucher_f = 000000000
      voucher_t = 999999999

      date_f = 0000
      date_t = 9999

      journal_f = "A"
      journal_t = "ZZZZZZZZ"
      .
   end.


   for each CInvoice  exclusive-lock        

      
   where    CInvoice.CInvoiceVoucher       >=  voucher_f 
   and    CInvoice.CInvoiceVoucher       <=    voucher_t
   and    CInvoice.CInvoicePostingYear       >=  date_f
   and    CInvoice.CInvoicePostingYear       <=  date_t

and CInvoice.CInvoiceDueDate     >=  v_datev_from
   and    CInvoice.CInvoiceDueDate     <=  v_datev_to
   and    CInvoice.CInvoiceDate        >=  v_datef_from
   and    CInvoice.CInvoiceDate        <=  v_datef_to
   and    Cinvoice.CustomCombo0        =    i_exp
   and    (CInvoice.CInvoiceType = "CREDITNOTE" 
            OR CInvoice.CInvoiceType = "INVOICE")
   ,first  Creditor  no-lock
   where  Creditor.Creditor_ID   =   CInvoice.Creditor_ID  
   and    Creditor.CreditorCode  >=  v_four_from
   and    Creditor.CreditorCode  <=  v_four_to                                                     
   ,first  Company                               
   where  Company.Company_ID    =  CInvoice.Company_ID   
   and    Company.CompanyCode  >=  v_entity_from
   and    Company.CompanyCode  <=  v_entity_to  

   ,first  Reason                               
   where  Reason.Reason_ID    =  CInvoice.Reason_ID
   and Reason.ReasonCode <> "AP-PO-INITIAL"
   and Reason.ReasonCode <> "AP-NPO-INITIAL"
   ,first  Journal                               
   where  Journal.Journal_ID    =  CInvoice.Journal_ID
   and Journal.JournalCode >= journal_f
   and Journal.JournalCode <= journal_t
   no-lock:


      if   Cinvoice.CinvoiceType = "INVOICE" then do:

         find first zz_cinvoice where zz_cinvoice.CinvoiceType = "CREDITNOTE" and zz_cinvoice.CInvoiceReference = Cinvoice.CInvoiceReference
         and zz_cinvoice.CustomCombo0 = Cinvoice.CustomCombo0 no-lock no-error.
         
         if available zz_cinvoice then do:
               next.
         end.

         find first CInvoicePO where CInvoicePO.CInvoice_ID = Cinvoice.CInvoice_ID no-lock no-error.

         if available CInvoicePO then do:
               if CInvoice.CInvoiceIsLogisticMatching = no then do: 
                  next.
               end.
               else do:

                  find first  APMatching                               
                  where APMatching.CInvoice_ID   =  CInvoice.CInvoice_ID
                  and APMatching.APMatchingStatus = "FINISHEDAPMATCHING" 
                  no-lock no-error.
                  
                  if (available CInvoicePO) = no then do: 
                     next.
                  end.

               end.
         end.

         /*else do:
               if Reason.ReasonCode <> "AP-NPO-Alloc" then next.
         end.*/
         

            
      end.

      if  Cinvoice.CinvoiceType = "CREDITNOTE" then do:

         find first zz_cinvoice where zz_cinvoice.CinvoiceType = "INVOICE" and zz_cinvoice.CInvoiceReference = Cinvoice.CInvoiceReference 
         and zz_cinvoice.CustomCombo0 = Cinvoice.CustomCombo0 no-lock no-error.

         if available zz_cinvoice then do:
               next.
         end.

      end.

      find first Division
      where Division.Division_ID = CInvoice.Division_ID 
      no-lock no-error.
      if available Division then v_subaccount = Division.DivisionCode. 

      find first Currency                                                      
      where CInvoice.CInvoiceCurrency_ID = Currency.Currency_ID   
      no-lock no-error. 
      if available Currency then v_currency_code = Currency.CurrencyCode.  
      define variable a as integer initial 0  no-undo.
      define variable b as character  initial "" no-undo.

      for each CInvoiceVat                                                
      where CInvoiceVat.Cinvoice_iD = Cinvoice.Cinvoice_ID                            
      no-lock:
         
         a = a + 1 .
         if a = 2 then do : 
            b = "" .
            leave. 
         end.
         find first vat 
         where CInvoiceVat.Vat_ID = Vat.Vat_ID
         no-lock no-error.
         if available vat then  b = string("D" + vat.VatCode + " " + "-" + " " + vat.VatDescription).
      end.

      num_line = num_line + 1.

      for each CInvoicePosting no-lock
      where CInvoicePosting.CInvoice_ID = CInvoice.CInvoice_ID
      ,first Posting no-lock                                                    
      where Posting.Posting_ID  = CInvoicePosting.Posting_ID                              
      , each postingline                                                    
      where PostingLine.Posting_ID = Posting.Posting_ID                            
      no-lock:
         
         
         
         find first GL 
         where GL.GL_ID  = Postingline.GL_ID
         no-lock no-error.

         if (GL.GLTypeCode = "SYSTEM" and GL.GLSystemTypeCode = "CIREC") then do:

            next.

         end.


            arr_line[1] = F_Date_Format(CInvoice.CInvoiceDate).
            if Cinvoice.CinvoiceType = "INVOICE" 
            then arr_line[2] = "FF".
            else arr_line[2] = "AF".
            
            arr_line[3] = GL.GLCode.
            
            if (string(GL.GLCode)  begins "408" OR string(GL.GLCode)  begins "9") then do:

               find first Division
               where Division.Division_ID = Postingline.Division_ID
               no-lock no-error.
               if available Division then 
               arr_line[3] = string(Division.DivisionCode).

               if (arr_line[3] = "" or decimal(arr_line[3]) = 0) then do:


                  for first APMatchingLN where APMatchingLN.PvoPostingLine_ID = PostingLine.PostingLine_ID:
                     
                     find first Division
                     where Division.Division_ID = APMatchingLN.Division_ID
                     no-lock no-error.
                     if available Division then 
                     arr_line[3] = string(Division.DivisionCode).

                  end.
               end.
            end.
               
            //R001

            arr_line[5] = "".
            //arr_line[5] = string("F" + Creditor.CreditorCode).
            
            arr_line[6] = "".


            arr_line[7] = "".
            arr_line[8] = "".

            define variable nbr_zero as integer.
            nbr_zero = 9 - LENGTH(string(CInvoice.CInvoiceVoucher)).
            define variable i as integer.
            define variable voucher as character.
            voucher = string(CInvoice.CInvoiceVoucher).
            DO i = 1 TO nbr_zero:
            voucher = "0" + voucher.
            END.

            arr_line[9] = string(CInvoice.CInvoicePostingYear) + "/" + string(Journal.JournalCode) + "/" + voucher.
            arr_line[10] = v_subaccount.
            arr_line[11] = CInvoice.CInvoiceDescription.
            arr_line[12] = "".
            
            arr_line[13] = "".
            //arr_line[13] = F_Date_Format(CInvoice.CInvoiceDueDate).

            arr_line[14] = "D" .

            arr_line[15] = string(PostingLine.PostingLineDebitLC - PostingLine.PostingLineCreditLC).

            if decimal(arr_line[15]) < 0 then do:
            arr_line[15] = string(- decimal(arr_line[15])).
            arr_line[14] = "C" .
            end.

            
            arr_line[16] = CInvoice.CInvoiceReference.

            arr_line[17] = b.

            
            
            arr_line[18] = v_currency_code.


            arr_line[19] = string(PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC).

            if (decimal(arr_line[19]) < 0) then
            arr_line[19] = string(-1 * decimal(arr_line[19])).

            
            arr_line[20] = F_Date_Format(CInvoice.CInvoicePostingDate).

            arr_line[21] = "".
            arr_line[22] = string(num_line).

            
            
            for each CInvoiceVat                                                
            where CInvoicevat.CInvoice_ID = CInvoice.CInvoice_ID                            
            no-lock:
               if (GL.GLTypeCode = "VAT"  and GL.GL_ID = CInvoiceVat.NormalTaxGL_ID ) then do:

                  find first vat
                  where CInvoiceVat.Vat_ID = Vat.Vat_ID
                  no-lock no-error.
                  if available vat then arr_line[17] = string("D" + vat.VatCode + " " + "-" + " " + vat.VatDescription).
     
                 
                  arr_line[4] = "G".
                  arr_line[21] = "".
                     
               end.

               else if (GL.GLTypeCode = "STANDARD" or GL.GLTypeCode = "SYSTEM" ) then do:


                  if (CInvoiceVat.CInvoiceVatVatBaseDebitTC - CInvoiceVat.CInvoiceVatVatBaseCreditTC) = 
                  (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC)
                  then do:
                     
                     find first vat 
                     where CInvoiceVat.Vat_ID = Vat.Vat_ID
                     no-lock no-error.
                     if available vat then arr_line[17] = string("D" + vat.VatCode + " " + "-" + " " + vat.VatDescription).

                  end.
               end.
            end.

            if arr_line[17] = "" then do:

               for first APMatchingLN where APMatchingLN.PvoPostingLine_ID = PostingLine.PostingLine_ID:
                  
                  for first APMatchingLNTax of APMatchingLN:
                     for first Vat of APMatchingLNTax:
                        arr_line[17] = string("D" + vat.VatCode + " " + "-" + " " + vat.VatDescription).
                     end.

                  end.

               end.

            end.
               


            if (GL.GLTypeCode = "SYSTEM" ) then do:

               arr_line[4] = "G".
               //arr_line[17] = "".
               /*find first PostingVat  
               where PostingVat.PostingLine_ID = PostingLine.PostingLine_ID
               no-lock no-error.
               if available PostingVat then find first vat                                                              
               where vat.vat_ID = PostingVat.vat_ID                            
               no-lock no-error.                                                          
               if available vat then arr_line[17] = "D" + vat.VatCode + " " + "-" + " " + vat.VatDescription.*/

             

               run add_row(input arr_line).
               Cinvoice.CustomCombo0 = "exp" .  

               arr_line[4] = "A".

               find first project                                                       
               where  Project.Project_ID = PostingLine.Project_ID
               no-lock no-error.

               find first CostCentre                                                    
               where CostCentre.CostCentre_ID = Postingline.CostCentre_ID               
               no-lock no-error.  
               
               if (available CostCentre) then
                     arr_line[6] = CostCentre.CostCentreCode. else arr_line[6] = "".

               arr_line[21] = "AXE1".
               
               run add_row(input arr_line).

               if (available Project) then
                     arr_line[6] = Project.ProjectCode. else arr_line[6] = "".

               arr_line[21] = "AXE2".
               run add_row(input arr_line).
   
               end.

            if (GL.GLTypeCode = "STANDARD") then do:

               arr_line[4] = "G".
               //arr_line[17] = "".
               /*find first PostingVat  
               where PostingVat.PostingLine_ID = PostingLine.PostingLine_ID
               no-lock no-error.
               if available PostingVat then find first vat                                                              
               where vat.vat_ID = PostingVat.vat_ID                            
               no-lock no-error.                                                          
               if available vat then arr_line[17] = "D" + vat.VatCode + " " + "-" + " " + vat.VatDescription.*/
               

               run add_row(input arr_line).
               Cinvoice.CustomCombo0 = "exp". 

               arr_line[4] = "A".

               find first project                                                       
               where  Project.Project_ID = PostingLine.Project_ID
               no-lock no-error.

               find first CostCentre                                                    
               where CostCentre.CostCentre_ID = Postingline.CostCentre_ID               
               no-lock no-error.  
                  
               if (available CostCentre) then
               arr_line[6] = CostCentre.CostCentreCode. else arr_line[6] = "".

               arr_line[21] = "AXE1".
               run add_row(input arr_line).

               if (available Project) then
                  arr_line[6] = Project.ProjectCode. else arr_line[6] = "".

               arr_line[21] = "AXE2".
               run add_row(input arr_line).

            end.

            if (GL.GLTypeCode = "VAT") then do:
            arr_line[4] = "V".
            if decimal(arr_line[19]) <> 0 
            then do :
               run add_row(input arr_line).
               Cinvoice.CustomCombo0 = "exp".
            //arr_line[17] = "".
            /*for each PostingVat  
            where PostingVat.PostingLine_ID = PostingLine.PostingLine_ID
            no-lock :
                  find first vat                                                              
                  where vat.vat_ID = PostingVat.vat_ID                            
                  no-lock no-error.
                  
                  if available vat then arr_line[17] = "D" + vat.VatCode + " " + "-" + " " + vat.VatDescription.

                  run add_row(input arr_line).

            end.*/
             
            end.
            end.

         if GL.GLTypeCode = "CREDITORCONTROL" then do:
            arr_line[5]   =  v_subaccount.
            /*arr_line[5] = string("F" + Creditor.CreditorCode).*/
            arr_line[4] = "X".
            arr_line[12] = "VI".
            arr_line[17] = "".
            arr_line[13] = F_Date_Format(CInvoice.CInvoiceDueDate).


            run add_row(input arr_line).
            Cinvoice.CustomCombo0 = "exp" .  
         end.



      end.    
                                                      
   end. 
   release Cinvoice.

   
end procedure.
