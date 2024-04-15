-- CreateTable
CREATE TABLE "Batches" (
    "id" SERIAL NOT NULL,
    "model" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "licenseLevel" INTEGER NOT NULL,
    "date" TEXT NOT NULL,
    "comment" TEXT,

    CONSTRAINT "Batches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MachineNumbers" (
    "id" SERIAL NOT NULL,
    "serial_number" TEXT NOT NULL,

    CONSTRAINT "MachineNumbers_pkey" PRIMARY KEY ("id")
);
