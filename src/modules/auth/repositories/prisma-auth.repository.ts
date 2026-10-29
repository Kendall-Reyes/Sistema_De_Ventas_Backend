import { Injectable } from '@nestjs/common';
import type { AuthRepository } from './auth.repository.js';

@Injectable()
export class PrismaAuthRepository implements AuthRepository {}
