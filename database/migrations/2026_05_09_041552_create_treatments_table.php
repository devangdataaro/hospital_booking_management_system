<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('treatments', function (Blueprint $table) {
            $table->id()->index();
            $table->string('title');
            $table->integer('duration'); // in minutes
            $table->decimal('price', 10, 2); // in USD
            $table->softDeletes(); // for soft delete support
            $table->timestamps();

            // Indexes for performance
            $table->index('title');
            $table->index(['duration', 'price']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('treatments');
    }
};
