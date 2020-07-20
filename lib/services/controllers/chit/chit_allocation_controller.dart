import 'package:instamfin/db/models/chit_allocations.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class ChitAllocationController {
  Future create(ChitFund chit, ChitFundDetails fund, int cNumber, bool isPaid,
      String notes) async {
    try {
      List<ChitAllocations> allocs = await ChitAllocations().getChitAllocations(
          chit.financeID, chit.branchName, chit.subBranchName, chit.chitID);
      int chits = 0;
      chit.customerDetails.forEach((cd) {
        if (cNumber == cd.number) {
          chits = cd.chits;
        }
      });

      List<int> aChits = [];

      allocs.forEach((chitAlloc) {
        if (chitAlloc.customer == cNumber) {
          aChits.add(chitAlloc.chitNumber);
          chits = chits - 1;
        }
      });

      if (chits == 0) {
        throw 'Already chits $aChits allocated for this customer';
      }

      ChitAllocations alloc = ChitAllocations();
      alloc.allocationAmount = fund.allocationAmount;
      alloc.financeID = chit.financeID;
      alloc.branchName = chit.branchName;
      alloc.subBranchName = chit.subBranchName;
      alloc.chitID = chit.chitID;
      alloc.chitNumber = fund.chitNumber;
      alloc.customer = cNumber;
      alloc.isPaid = isPaid;
      alloc.notes = notes;

      alloc = await alloc.create();

      return CustomResponse.getSuccesReponse(alloc);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateAllocationDetails(
      String financeId,
      String branchName,
      String subBranchName,
      String chitID,
      int chitNumber,
      bool isPaid,
      bool isAdd,
      Map<String, dynamic> alocationDetails) async {
    try {
      await ChitAllocations().updateAllocationDetails(financeId, branchName,
          subBranchName, chitID, chitNumber, isPaid, isAdd, alocationDetails);
      return CustomResponse.getSuccesReponse(
          "Allocation updated for Chit $chitID");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
