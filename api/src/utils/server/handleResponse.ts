import { Response } from "express";
import { ServerResponses } from "../enuns/serverResponses";

export const HandleResponse = {
    response(status: number, message: string, data: any, res: Response) {
        res.status(status).json({
            message: message,
            data: data
        });
    },

    error(res: Response) {
        res.status(500).json({
            message: ServerResponses.InternalError,
        })
    }
}