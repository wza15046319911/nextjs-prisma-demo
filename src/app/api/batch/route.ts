import { PrismaClient } from '@prisma/client'
import {NextResponse} from 'next/server';
import type {NextRequest} from 'next/server';
import { nanoid } from 'nanoid';

interface Batch {
    model: string;
    quantity: number;
    licenseLevel: number;
    date: string;
    comment ?: string;
}

interface MachineNumbers {
    serial_number: string;
    batch_id: number;
}

export async function POST(req: NextRequest) {
    const body = await req.json();
    // const {batch} = body;
    const batch: Batch = body.batch;
    const quantity: number = batch.quantity
    const prisma = new PrismaClient()
    const result = await prisma.batches.create({
        data: batch
    })
    const machineNumbers: MachineNumbers[] = [];
    for (let i = 0; i < quantity; i++) {
        machineNumbers.push({
            serial_number: nanoid(),
            batch_id: result.id
        });
    }

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