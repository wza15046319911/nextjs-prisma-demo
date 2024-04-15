import { PrismaClient } from '@prisma/client'
import {NextResponse} from 'next/server';
import type {NextRequest} from 'next/server';
import { nanoid } from 'nanoid';

export async function POST(req: NextRequest, res: NextResponse) {
    const body = await req.json();
    const {batch} = body;
    const quantity: number = batch.quantity
    const prisma = new PrismaClient()
    const result = await prisma.batches.create({
        data: batch
    })
    const machineNumbers = [];
    for (let i = 0; i < quantity; i++) {
        machineNumbers.push({
            serial_number: nanoid(), // 生成唯一的随机字符串
            batch_id: result.id
        });
    }

    // 批量创建 machine_numbers 条目
    // @ts-ignore
    await prisma.machine_numbers.createMany({
        data: machineNumbers
    });
    return NextResponse.json(
        {
            message: "success",
        },
        {
            status: 200,
        },
    );
}