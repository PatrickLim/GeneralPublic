using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using PDCI;
using PTC;
using platform;

namespace GeneralPublic.Controllers
{
    public class MemberController : ApiController
    {
        string sConnPTC = System.Configuration.ConfigurationManager.ConnectionStrings["conn"].ConnectionString;
        string sConnPDCI = System.Configuration.ConfigurationManager.ConnectionStrings["pdci"].ConnectionString;

        [HttpGet]
        [ActionName("login")]
        public MemberAccountModel MemberLogin(string email, string password)
        {
            MemberAccountHandler h = new MemberAccountHandler(sConnPDCI);
            MemberAccountModel resp = h.GetMemberByEmail(email, password);
            return resp;
        }

        [HttpPost]
        [ActionName("reload")]
        public MemberCardReloadResponseModel Reload(MemberCardReloadRequestModel r)
        {
            PaymentHandler h = new PaymentHandler(sConnPTC, sConnPDCI);
            MemberCardReloadResponseModel resp = h.ReloadMemberCard(r);
            return resp;
        }

        [HttpGet]
        [ActionName("transdetails")]
        public List<MachineTransactionDetailModel> GetTransDetails(int id)
        {
            TransactionHandler h = new TransactionHandler(sConnPTC);
            List<MachineTransactionDetailModel> resp = h.GetTransactionDetails(id);
            return resp;
        }

        [HttpPost]
        [ActionName("savemember")]
        public void SaveMember(MemberModel m)
        {
            MemberAccountHandler h = new MemberAccountHandler(sConnPDCI);
            h.SaveMember(m);
        }
    }
}
