import { JwtPayload } from "jsonwebtoken";
import { Security } from "../../utils/server/security";
import { searchCompany } from "../../utils/company/searchCompany";

export async function GenerateLink(token: string) {
    const { id } = Security.verify(token) as JwtPayload;
    const companyId = await searchCompany(id);

    const tokenLink = Security.signLink(companyId);

    return `http://teste.com/user/register/token?=${tokenLink}`;
}